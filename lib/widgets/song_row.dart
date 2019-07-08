
import 'package:flutter/material.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';

class SongRow extends StatelessWidget {
  final String title;
  final String artist;
  final int number;
  final bool isActive;
  const SongRow(
      {Key key, @required this.title, this.artist, @required this.number, this.isActive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: isActive ? secondary : Colors.transparent,
      padding: EdgeInsets.only(left: AppSpace.sm),
      child: Center(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: AppSpace.lg,
              child: Text(
                '$number',
                style:
                    TextStyle(fontSize: AppFont.sm + 2, color: secondaryText),
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(
                      color: accentText,
                      fontWeight: FontWeight.w700,
                      fontSize: AppFont.md - 2,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '$title\n'),
                      TextSpan(
                          text: '$artist',
                          style: TextStyle(
                              color: secondaryText,
                              fontSize: AppFont.sm,
                              height: 1.3)),
                    ]),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(0.0),
              width: 25.0,
              child: IconButton(
                icon: Icon(Icons.favorite_border),
                iconSize: AppFont.md - 3,
                onPressed: () {},
                color: secondaryText,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(0.0),
              width: 40.0,
              child: IconButton(
                icon: Icon(Icons.more_vert),
                iconSize: AppFont.md,
                onPressed: () {},
                color: secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
