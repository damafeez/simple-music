import 'package:flutter/material.dart';
import 'package:simple_music_player/data/models/lyrics.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';

class PlayerLyrics extends StatelessWidget {
  final Lyrics lyrics;
  const PlayerLyrics({
    Key key,
    this.lyrics,
  }) : super(key: key);

  List<TextSpan> _buildLyrics() {
    List<TextSpan> _lyricsWidget = <TextSpan>[];
    final _lyrics = lyrics.formattedLyrics;

    for (int i = 0; i < _lyrics.length; i++) {
      _lyricsWidget.add(new TextSpan(
        text: '${_lyrics[i]}\n',
        style: lyrics.activeIndex == i
            ? TextStyle(color: primary, fontWeight: FontWeight.w700)
            : null,
      ));
    }
    return _lyricsWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: SingleChildScrollView(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: '',
              style: TextStyle(
                color: secondaryText,
                fontWeight: FontWeight.w600,
                height: 1.3,
                fontSize: AppFont.md - 2,
              ),
              children: _buildLyrics()),
        ),
      ),
    );
  }
}
