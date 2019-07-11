import 'package:flutter/material.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';

class PlayerControls extends StatelessWidget {
  final MusicEngine musicEngine;

  const PlayerControls({Key key, this.musicEngine}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isPlaying = musicEngine.playerState == PlayerState.playing;
    final currentIndex = musicEngine.currentSongIndex;
    final hasNextSong = musicEngine.currentSongIndex < musicEngine.length - 1;
    final hasPrevSong = musicEngine.currentSongIndex > 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpace.sm - 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              size: 22,
              color: secondaryText,
            ),
            onPressed: () => null,
          ),
          IconButton(
            icon: Icon(
              Icons.skip_previous,
              size: 30.0,
            ),
            onPressed: hasPrevSong ? () => musicEngine.playPrevSong() : null,
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 30.0,
            ),
            onPressed: () {
              musicEngine.play(currentIndex);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.skip_next,
              size: 30.0,
            ),
            onPressed: hasNextSong ? () => musicEngine.playNextSong() : null,
          ),
          IconButton(
            icon: Icon(
              Icons.shuffle,
              size: 22.0,
              color: secondaryText,
            ),
            onPressed: () => null,
          ),
        ],
      ),
    );
  }
}
