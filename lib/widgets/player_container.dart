import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_music_player/data/fixtures/lyrics.dart';
import 'package:simple_music_player/resources/assets.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/widgets/player_controls.dart';
import 'package:simple_music_player/widgets/player_lyrics.dart';
import 'package:simple_music_player/widgets/player_timeline.dart';

class PlayerContainer extends StatelessWidget {
  final double panPercent;
  final minAlbulmArtWidth = 50;
  const PlayerContainer({
    this.panPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(0, 250 * panPercent),
            child: SafeArea(
              bottom: false,
              child: Opacity(
                opacity: (1 - 2 * panPercent).clamp(0.0, 1.0),
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
            offset: Offset(0, -100 * panPercent),
                      child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpace.sm),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final width = constraints.maxWidth;
                  return Row(
                    children: <Widget>[
                      Container(
                        width: lerpDouble(width, minAlbulmArtWidth, panPercent),
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
                    ],
                  );
                },
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, 200 * panPercent),
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
    );
  }
}
