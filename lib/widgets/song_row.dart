import 'package:flutter/material.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/resources/utils.dart';

class SongRow extends StatelessWidget {
  final String title;
  final String artist;
  final int number;
  final bool isActive;
  final bool isPlaying;
  const SongRow(
      {Key key, @required this.title, this.artist, @required this.number, this.isActive = false, this.isPlaying = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 75,
      color: secondary.withOpacity(isActive ? 1 : 0),
      padding: EdgeInsets.only(left: AppSpace.sm),
      child: Center(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: AppSpace.lg,
              child: Align(
                alignment: Alignment.centerLeft,
                              child: isActive && isPlaying ? Icon(Icons.pause, size: AppFont.md + 2,) : Text(
                  '$number',
                  style:
                      TextStyle(fontSize: AppFont.sm + 2, color: secondaryText),
                ),
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(
                      color: accentText,
                      fontWeight: FontWeight.w600,
                      fontSize: AppFont.md - 2,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '${Utils.truncate(title, 28)}\n'),
                      TextSpan(
                          text: '${Utils.truncate(artist, 40)}',
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
