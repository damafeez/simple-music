import 'package:flutter/material.dart';
import 'package:simple_music_player/data/fixtures/lyrics.dart';
import 'package:simple_music_player/resources/assets.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/widgets/player_controls.dart';
import 'package:simple_music_player/widgets/player_lyrics.dart';
import 'package:simple_music_player/widgets/player_timeline.dart';

class PlayerContainer extends StatelessWidget {
  const PlayerContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppSpace.md,
        left: AppSpace.sm,
        right: AppSpace.sm,
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.arrow_back,
                color: primary,
              ),
              RichText(
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
              Icon(
                Icons.more_vert,
                color: primary,
              ),
            ],
          ),
          Container(
            height: 320,
            margin: EdgeInsets.symmetric(vertical: AppSpace.md),
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
          PlayerLyrics(lyrics: siaLyrics),
          PlayerTimeline(),
          PlayerControls(),
        ],
      ),
    );
  }
}
