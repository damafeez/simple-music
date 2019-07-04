import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_music_player/data/fixtures/lyrics.dart';
import 'package:simple_music_player/resources/assets.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/widgets/player_controls.dart';
import 'package:simple_music_player/widgets/player_lyrics.dart';
import 'package:simple_music_player/widgets/player_timeline.dart';

class PlayerContainer extends StatefulWidget {
  final double panPercent;
  final Function(double) panUpdateCallback;
  final Function panEndCallback;

  PlayerContainer({
    this.panPercent,
    @required this.panUpdateCallback,
    @required this.panEndCallback,
  });

  @override
  _PlayerContainerState createState() => _PlayerContainerState();
}

class _PlayerContainerState extends State<PlayerContainer> {
  final minAlbulmArtWidth = 50.0;
  final dragAutoCompletePercent = 0.4;

  double startDragY;
  double startDragPercent;
  double dragDistance;
  double dragPercent;
  DragIntent dragIntent = DragIntent.none;

  void _onPanStart(DragStartDetails details) {
    startDragY = details.globalPosition.dy;
    startDragPercent = widget.panPercent;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (startDragY != null) {
      dragDistance = details.globalPosition.dy - startDragY;

      if (dragDistance > 0 && startDragPercent == 0)
        dragIntent = DragIntent.close;
      else if (dragDistance < 0 && startDragPercent == 1)
        dragIntent = DragIntent.open;
      else
        dragIntent = DragIntent.none;

      final fullDragHeight = context.size.height - 100;

      dragPercent = dragDistance / fullDragHeight;
      final double total = (startDragPercent + dragPercent).clamp(0.0, 1.0);

      widget.panUpdateCallback(total);
    }
  }

  void _onPanEnd(DragEndDetails dragEndDetails) {
    if (dragIntent == DragIntent.close) {
      widget.panUpdateCallback(
          dragPercent.abs() >= dragAutoCompletePercent ? 1.0 : 0.0);
    } else if (dragIntent == DragIntent.open) {
      widget.panUpdateCallback(
          dragPercent.abs() >= dragAutoCompletePercent ? 0.0 : 1.0);
    }
    startDragY = null;
    startDragPercent = null;
    dragIntent = DragIntent.none;
    widget.panEndCallback();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onPanStart,
      onVerticalDragUpdate: _onPanUpdate,
      onVerticalDragEnd: _onPanEnd,
      child: Container(
        color: background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Transform.translate(
              offset: Offset(0, 250.0 * widget.panPercent),
              child: SafeArea(
                bottom: false,
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
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: AppSpace.sm, bottom: AppSpace.md),
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
                                TextSpan(text: 'Cheap Thrills\n'),
                                TextSpan(
                                    text: 'Sia',
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
            ),
            Transform.translate(
              offset: Offset(0, -100 * widget.panPercent),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpace.sm),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final width = constraints.maxWidth;
                    return Row(
                      children: <Widget>[
                        Container(
                          width: lerpDouble(
                              width, minAlbulmArtWidth, widget.panPercent),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: ExactAssetImage(SIA),
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
                        Expanded(
                          child: Container(child: Text(' ')),
                        ),
                      ],
                    );
                  },
                ),
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

enum DragIntent {
  open,
  close,
  none,
}
