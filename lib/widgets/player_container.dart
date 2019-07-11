import 'dart:async';
import 'dart:ui';
import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_music_player/data/fixtures/lyrics.dart';
import 'package:simple_music_player/data/store/app_state.dart';
import 'package:simple_music_player/resources/assets.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/widgets/player_bar.dart';
import 'package:simple_music_player/widgets/player_controls.dart';
import 'package:simple_music_player/widgets/player_lyrics.dart';
import 'package:simple_music_player/widgets/player_timeline.dart';

class PlayerContainer extends StatefulWidget {
  final double panPercent;
  final Function(double) panUpdateCallback;
  final ScrollController scaffoldScrollController;
  final StreamController closeStreamController;
  final AppState model;

  PlayerContainer({
    @required this.panPercent,
    @required this.panUpdateCallback,
    @required this.scaffoldScrollController,
    @required this.closeStreamController,
    @required this.model,
  });

  @override
  _PlayerContainerState createState() => _PlayerContainerState();
}

class _PlayerContainerState extends State<PlayerContainer>
    with SingleTickerProviderStateMixin {
  final dragAutoCompletePercent = 0.35;

  double startDragY;
  double startDragPercent;
  double dragDistance;
  double dragPercent;
  DragDirection dragDirection = DragDirection.none;

  Tween<double> dragAutoCompleteAnimationTween;
  AnimationController dragAutoCompleteAnimationController;
  CurvedAnimation curvedAnimation;

  @override
  void initState() {
    dragAutoCompleteAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this)
          ..addListener(() {
            widget.panUpdateCallback(
                dragAutoCompleteAnimationTween.evaluate(curvedAnimation));
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              dragDirection = DragDirection.none;
              dragAutoCompleteAnimationTween = null;
            }
          });

    curvedAnimation = CurvedAnimation(
        parent: dragAutoCompleteAnimationController, curve: Curves.easeOut);

    widget.closeStreamController.stream.listen((data) {
      _animateContainer(false);
    });
  }

  @override
  void dispose() {
    dragAutoCompleteAnimationController.dispose();
    super.dispose();
  }

  bool _gestureDisabled() {
    return (widget.scaffoldScrollController.offset !=
        widget.scaffoldScrollController.position.minScrollExtent) ||
        widget.model.currentSongIndex < 0;
  }
  void _onPanStart(DragStartDetails details) {
    if (_gestureDisabled()) return;

    startDragY = details.globalPosition.dy;
    startDragPercent = widget.panPercent;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_gestureDisabled()) return;    

    if (startDragY != null) {
      dragDistance = details.globalPosition.dy - startDragY;

      if (dragDistance > 0 && startDragPercent == 0)
        dragDirection = DragDirection.down;
      else if (dragDistance < 0 && startDragPercent == 1)
        dragDirection = DragDirection.up;
      else
        dragDirection = DragDirection.none;

      final fullDragHeight = context.size.height - 100;

      dragPercent = dragDistance / fullDragHeight;
      final double total = (startDragPercent + dragPercent).clamp(0.0, 1.0);

      widget.panUpdateCallback(total);
    }
  }

  void _onPanEnd(DragEndDetails dragEndDetails) {
    if (_gestureDisabled()) return;    

    if (dragDirection == DragDirection.down) {
      _animateContainer(
          dragPercent.abs() >= dragAutoCompletePercent ? false : true);
    } else if (dragDirection == DragDirection.up) {
      _animateContainer(
          dragPercent.abs() >= dragAutoCompletePercent ? true : false);
    }
    startDragY = null;
    startDragPercent = null;
  }

  void _animateContainer(open) {
    if ((open && widget.panPercent == 0.0) ||
        (!open && widget.panPercent == 1.0)) return;

    final double scrollTop =
        widget.scaffoldScrollController.position.minScrollExtent;

    if (widget.scaffoldScrollController.offset != scrollTop) {
      widget.scaffoldScrollController.animateTo(
        scrollTop,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
    // calculate duraction based on distance to end
    final distanceToEnd = (widget.panPercent - (open ? 0.0 : 1.0)).abs();
    dragAutoCompleteAnimationController.duration =
        Duration(milliseconds: (400 * distanceToEnd).clamp(200, 400).round());
    print('${dragAutoCompleteAnimationController.duration}=====');
    dragAutoCompleteAnimationTween =
        Tween(begin: widget.panPercent, end: open ? 0.0 : 1.0);
    dragAutoCompleteAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    if(widget.model.songsLoading) return Container();
    final int currentSongIndex = widget.model.currentSongIndex;
    final Song song = widget.model.songs[currentSongIndex];

    final albumImageFile =
        song.albumArt == null ? null : File.fromUri(Uri.parse(song.albumArt));

    return GestureDetector(
      onVerticalDragStart: _onPanStart,
      onVerticalDragUpdate: _onPanUpdate,
      onVerticalDragEnd: _onPanEnd,
      onTap: () => _animateContainer(true),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: BorderSide(
              color: secondaryText.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Transform.translate(
              offset: Offset(0, 250.0 * widget.panPercent),
              child: Opacity(
                opacity: (1 - 2 * widget.panPercent).clamp(0.0, 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: primary,
                      ),
                      onPressed: () => _animateContainer(false),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: AppSpace.md + 17, bottom: AppSpace.md),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: '',
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w700,
                              fontSize: AppFont.md,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: '${song.title}\n'),
                              TextSpan(
                                  text: song.artist,
                                  style: TextStyle(
                                      color: secondaryText,
                                      fontSize: AppFont.md - 3,
                                      height: 1.5)),
                            ]),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: primary,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -110 * widget.panPercent),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final width = constraints.maxWidth;

                  return Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: AppSpace.sm + collapsedAlbumArtWidth),
                        child: Transform.translate(
                          offset: Offset(-50.0 * (1 - widget.panPercent),
                              -100.0 * (1 - widget.panPercent)),
                          child: Opacity(
                            opacity:
                                ((widget.panPercent * 3) - 2).clamp(0.0, 1.0),
                            child: PlayerBar(title: song.title, artist: song.artist),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpace.sm),
                        child: Container(
                          width: lerpDouble(
                              width, collapsedAlbumArtWidth, widget.panPercent),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                        image: albumImageFile != null ?
                                        FileImage(albumImageFile) : ExactAssetImage(SIA),
                                        fit: BoxFit.cover,
                                      ),
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(50, 50, 50, 0.4),
                                    blurRadius: 25,
                                    offset: Offset(7.0, 12.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Transform.translate(
              offset: Offset(0, 200 * widget.panPercent),
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppSpace.sm,
                  top: AppSpace.md,
                  right: AppSpace.sm,
                ),
                child: Column(
                  children: <Widget>[
                    PlayerLyrics(lyrics: siaLyrics),
                    PlayerTimeline(),
                    PlayerControls(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum DragDirection {
  up,
  down,
  none,
}
