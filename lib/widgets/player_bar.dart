import 'package:flutter/material.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';

class PlayerBar extends StatelessWidget {
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
                    TextSpan(text: 'Cheap Thrills\n'),
                    TextSpan(
                        text: 'Sia',
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
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: () {},
        ),
      ],
    );
  }
}
