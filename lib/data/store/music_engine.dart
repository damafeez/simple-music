import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flute_music_player/flute_music_player.dart';

enum PlayerState { stopped, playing, paused }

class MusicEngine extends ChangeNotifier {
  final MusicFinder _audioPlayer;
  List<Song> _songs;
  bool _songsLoading = false;
  int currentSongIndex = -1;
  PlayerState playerState = PlayerState.stopped;

  MusicEngine() : _audioPlayer = MusicFinder();

  MusicFinder get audioPlayer => _audioPlayer;
  int get length => _songs.length;
  bool get songsLoading => _songsLoading;

  List<Song> get songs {
    return _songs;
  }

  Future playNextSong() {
    if (currentSongIndex < length - 1) {
      return playSong(currentSongIndex + 1);
    }
  }

  Future playPrevSong() {
    if (currentSongIndex > 0) {
      return playSong(currentSongIndex - 1);
    }
  }

  Future playSong(int index, {bool shouldStop = true}) async {
    final song = songs[index];
    if (song != null) {
      if (shouldStop && playerState != PlayerState.stopped) {
        await stop();
      }
      final result = await _audioPlayer.play(song?.uri, isLocal: true);

      if (result == 1) {
        playerState = PlayerState.playing;

        currentSongIndex = index;
        notifyListeners();
      }
    }
  }

  void play(int index) {
    if (index == currentSongIndex)
      playerState == PlayerState.playing
          ? pause()
          : playSong(index, shouldStop: false);
    else
      playSong(index);
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
