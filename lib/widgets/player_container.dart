import 'dart:async';
import 'dart:ui';
import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_music_player/data/fixtures/lyrics.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/assets.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/resources/utils.dart';
import 'package:simple_music_player/widgets/navigation_logic.dart';
import 'package:simple_music_player/widgets/player_bar.dart';
import 'package:simple_music_player/widgets/player_controls.dart';
import 'package:simple_music_player/widgets/player_lyrics.dart';
import 'package:simple_music_player/widgets/player_timeline.dart';

class PlayerContainer extends StatefulWidget {
  final PlayerContainerViewModel viewModel;

  PlayerContainer(this.viewModel);

  @override
  _PlayerContainerState createState() => _PlayerContainerState();
}

class _PlayerContainerState extends State<PlayerContainer>
    with SingleTickerProviderStateMixin {
  final dragAutoCompletePercent = 0.35;

  DragDirection dragDirection = DragDirection.none;
  Color albumArtShadowColor = Color.fromRGBO(70, 70, 70, 0.4);

  double startDragY;
  double startDragPercent;
  double dragDistance;
  double dragPercent;

  Tween<double> dragAutoCompleteAnimationTween;
  AnimationController dragAutoCompleteAnimationController;
  CurvedAnimation curvedAnimation;

  @override
  void initState() {
    dragAutoCompleteAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this)
          ..addListener(() {
            widget.viewModel.panUpdateCallback(
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

    widget.viewModel.navigationLogicEvents.stream.listen((event) {
      switch (event) {
        case NavigationLogicEvents.collapsePlayer:
          _animateContainer(open: false);
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    dragAutoCompleteAnimationController.dispose();
    widget.viewModel.musicEngine.stop();
    super.dispose();
  }

  bool _gestureDisabled() {
    return (widget.viewModel.scaffoldScrollController.offset !=
            widget
                .viewModel.scaffoldScrollController.position.minScrollExtent);
  }

  void _onPanStart(DragStartDetails details) {
    if (_gestureDisabled()) return;

    startDragY = details.globalPosition.dy;
    startDragPercent = widget.viewModel.panPercent;
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

      widget.viewModel.panUpdateCallback(total);
    }
  }

  void _onPanEnd(DragEndDetails dragEndDetails) {
    if (_gestureDisabled()) return;

    if (dragDirection == DragDirection.down) {
      _animateContainer(
          open: dragPercent.abs() >= dragAutoCompletePercent ? false : true);
    } else if (dragDirection == DragDirection.up) {
      _animateContainer(
          open: dragPercent.abs() >= dragAutoCompletePercent ? true : false);
    }
    startDragY = null;
    startDragPercent = null;
  }

  void _animateContainer({open = true}) {
    if ((open && widget.viewModel.panPercent == 0.0) ||
        (!open && widget.viewModel.panPercent == 1.0)) return;

    final double scrollTop =
        widget.viewModel.scaffoldScrollController.position.minScrollExtent;

    if (widget.viewModel.scaffoldScrollController.offset != scrollTop) {
      widget.viewModel.scaffoldScrollController.animateTo(
        scrollTop,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
    // calculate duraction based on distance to end
    final distanceToEnd =
        (widget.viewModel.panPercent - (open ? 0.0 : 1.0)).abs();
    dragAutoCompleteAnimationController.duration =
        Duration(milliseconds: (400 * distanceToEnd).clamp(200, 400).round());
    dragAutoCompleteAnimationTween =
        Tween(begin: widget.viewModel.panPercent, end: open ? 0.0 : 1.0);
    dragAutoCompleteAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final int currentSongIndex = widget.viewModel.musicEngine.currentSongIndex;
    final Song song = widget.viewModel.musicEngine.songs[currentSongIndex];
    return GestureDetector(
      // onVerticalDragStart: _onPanStart,
      // onVerticalDragUpdate: _onPanUpdate,
      // onVerticalDragEnd: _onPanEnd,
      onVerticalDragStart: null,
      onVerticalDragUpdate: null,
      onVerticalDragEnd: null,
      onTap: () => _animateContainer(),
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
              offset: Offset(0, 250.0 * widget.viewModel.panPercent),
              child: Opacity(
                opacity: (1 - 2 * widget.viewModel.panPercent).clamp(0.0, 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: primary,
                      ),
                      onPressed: () => _animateContainer(open: false),
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
                              TextSpan(
                                  text: '${Utils.truncate(song.title, 25)}\n'),
                              TextSpan(
                                  text: '${Utils.truncate(song.artist, 28)}',
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
              offset: Offset(0, -110 * widget.viewModel.panPercent),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final width = constraints.maxWidth;
                  return Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: AppSpace.sm + collapsedAlbumArtWidth),
                        child: Transform.translate(
                          offset: Offset(
                              -50.0 * (1 - widget.viewModel.panPercent),
                              -100.0 * (1 - widget.viewModel.panPercent)),
                          child: Opacity(
                            opacity: ((widget.viewModel.panPercent * 3) - 2)
                                .clamp(0.0, 1.0),
                            child: PlayerBar(
                                title: song.title,
                                artist: song.artist,
                                musicEngine: widget.viewModel.musicEngine),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpace.sm),
                        child: Container(
                          width: lerpDouble(width, collapsedAlbumArtWidth,
                              widget.viewModel.panPercent),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: song.albumArt != null
                                      ? FileImage(File.fromUri(
                                          Uri.parse(song.albumArt)))
                                      : ExactAssetImage(ALBUM_PLACEHOLDER),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: albumArtShadowColor,
                                    blurRadius: (30 * (1 - widget.viewModel.panPercent)),
                                    offset: Offset(0.0, 10.0 * (1 - widget.viewModel.panPercent)),
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
              offset: Offset(0, 200 * widget.viewModel.panPercent),
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
                    PlayerControls(musicEngine: widget.viewModel.musicEngine),
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

class PlayerContainerViewModel {
  final double panPercent;
  final Function(double) panUpdateCallback;
  final ScrollController scaffoldScrollController;
  final StreamController<NavigationLogicEvents> navigationLogicEvents;
  final MusicEngine musicEngine;

  PlayerContainerViewModel({
    @required this.panPercent,
    @required this.panUpdateCallback,
    @required this.scaffoldScrollController,
    @required this.navigationLogicEvents,
    @required this.musicEngine,
  });
}

enum DragDirection {
  up,
  down,
  none,
}
