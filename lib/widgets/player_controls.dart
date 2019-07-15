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
    final hasNextSong = currentIndex < musicEngine.length - 1;
    final hasPrevSong = currentIndex > 0;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpace.sm - 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              size: 22,
              color: musicEngine.songs[currentIndex].isFavorite ? Colors.red.withOpacity(0.8) : secondaryText.withOpacity(0.5),
            ),
            onPressed: () => musicEngine.makeFavorite(currentIndex),
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
              musicEngine.replayMode == ReplayMode.one ? Icons.repeat_one : Icons.repeat,
              size: 22.0,
              color:
                  musicEngine.replayMode == ReplayMode.none ? secondaryText.withOpacity(0.5) : null,
            ),
            onPressed: () {
              final values = ReplayMode.values;
              int currentIndex = values.indexOf(musicEngine.replayMode);
              final ReplayMode nextMode = currentIndex == values.length - 1
                  ? values[0]
                  : values[currentIndex + 1];
              musicEngine.setReplayMode(nextMode);
            },
          ),
        ],
      ),
    );
  }
}
