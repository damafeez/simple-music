import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flute_music_player/flute_music_player.dart';

enum PlayerState { stopped, playing, paused }

class MusicEngine extends ChangeNotifier {
  final MusicFinder _audioPlayer;
  bool _songsLoading = false;
  ReplayMode _replayMode = ReplayMode.none;
  List<Song> _songs;
  int currentSongIndex = -1;
  PlayerState playerState = PlayerState.stopped;

  MusicEngine() : _audioPlayer = MusicFinder() {
    _audioPlayer.setCompletionHandler(onComplete);
  }

  MusicFinder get audioPlayer => _audioPlayer;
  int get length => _songs.length;
  bool get songsLoading => _songsLoading;
  ReplayMode get replayMode => _replayMode;
  List<Song> get songs => _songs;

  void setReplayMode(ReplayMode mode) {
    _replayMode = mode;

    notifyListeners();
  }

  Future onComplete() {
    switch (replayMode) {
      case ReplayMode.none:
        return playNextSong();
      case ReplayMode.one:
        return playSong(currentSongIndex);
      case ReplayMode.all:
        if (currentSongIndex == length - 1) {
          return playSong(0);
        }
        return playNextSong();
      default:
    }
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

enum ReplayMode {
  none,
  one,
  all,
}

class SongsCollection {
  final List<Song> songs;
  final String image;

  SongsCollection(this.songs, this.image);
}
