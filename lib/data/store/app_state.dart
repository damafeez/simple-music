import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flute_music_player/flute_music_player.dart';

enum PlayerState { stopped, playing, paused }

class AppState extends ChangeNotifier {
  List<Song> _songs;
  bool _songsLoading = false;
  int currentSongIndex = -1;
  MusicFinder _audioPlayer = MusicFinder();
  PlayerState playerState = PlayerState.stopped;

  MusicFinder get audioPlayer => _audioPlayer;
  int get length => _songs.length;
  bool get songsLoading => _songsLoading;

  List<Song> get songs {
    return _songs;
  }

  int get nextSong {
    if (currentSongIndex < length) {
      return currentSongIndex + 1;
    } else
      return null;
  }

  int get prevSong {
    if (currentSongIndex > 0) {
      return currentSongIndex - 1;
    } else
      return null;
  }

  Future play(int index) async {
    final song = songs[index];
    if (song != null) {
      final result = await _audioPlayer.play(song.uri, isLocal: true);
      if (result == 1) {
        playerState = PlayerState.playing;
        currentSongIndex = index;

        notifyListeners();
      }
    }
  }

  Future pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      playerState = PlayerState.paused;

      notifyListeners();
    }
  }

  Future stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      playerState = PlayerState.stopped;

      notifyListeners();
    }
  }

  Song get randomSong {
    Random random = Random();
    return _songs[random.nextInt(_songs.length)];
  }

  refresh() async {
    _songsLoading = true;
    _songs = await MusicFinder.allSongs();
    _songsLoading = false;

    notifyListeners();
  }
}
