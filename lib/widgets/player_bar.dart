import 'package:flutter/material.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';

class PlayerBar extends StatelessWidget {
  final String title;
  final String artist;

  const PlayerBar({Key key, this.title, this.artist}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpace.xs),
            child: RichText(
              text: TextSpan(
                  text: '',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontSize: AppFont.md - 3,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '${title}\n'),
                    TextSpan(
                        text: '$artist',
                        style: TextStyle(
                            color: secondaryText,
                            fontSize: AppFont.sm,
                            height: 1.3)),
                  ]),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.play_arrow),
          iconSize: AppFont.lg,
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.skip_next),
          iconSize: AppFont.lg,
          onPressed: () {},
        ),
      ],
    );
  }
}
