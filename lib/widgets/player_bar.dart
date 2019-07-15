import 'package:flutter/material.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/resources/utils.dart';

class PlayerBar extends StatelessWidget {
  final String title;
  final String artist;
  final MusicEngine musicEngine;

  const PlayerBar({Key key, this.title, this.artist, this.musicEngine})
      : super(key: key);
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
                    TextSpan(text: '${truncate(title, 40)}\n'),
                    TextSpan(
                        text: '${truncate(artist, 25)}',
                        style: TextStyle(
                            color: secondaryText,
                            fontSize: AppFont.sm,
                            height: 1.3)),
                  ]),
            ),
          ),
        ),
        IconButton(
          icon: Icon(musicEngine.playerState == PlayerState.playing ? Icons.pause :Icons.play_arrow),
          iconSize: AppFont.lg,
          onPressed: () {
            musicEngine.play(musicEngine.currentSongIndex);
          },
        ),
        IconButton(
          icon: Icon(Icons.skip_next),
          iconSize: AppFont.lg,
          onPressed: musicEngine.currentSongIndex < musicEngine.length - 1
              ? () => musicEngine.playNextSong()
              : null,
        ),
      ],
    );
  }
}
