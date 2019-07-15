import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:simple_music_player/resources/utils.dart';

class MusicEngine extends ChangeNotifier {
  final MusicFinder _audioPlayer;

  bool _songsLoading = false;
  ReplayMode _replayMode = ReplayMode.none;
  int currentSongIndex = -1;
  PlayerState playerState = PlayerState.stopped;
  Set<int> _favorites = <int>{};
  MusicSource musicSource = MusicSource.tracks;
  List<SimpleSong> _songs = <SimpleSong>[];
  Map<MusicSource, List<SimpleSong>> collection =
      <MusicSource, List<SimpleSong>>{};
  LocalStore _localStore;

  MusicEngine()
      : _audioPlayer = MusicFinder(),
        _localStore = LocalStore() {
    _audioPlayer.setCompletionHandler(onComplete);
  }

  MusicFinder get audioPlayer => _audioPlayer;
  int get length => _songs.length;
  bool get songsLoading => _songsLoading;
  ReplayMode get replayMode => _replayMode;
  List<SimpleSong> get songs => collection[musicSource];
  Set<int> get favorites => _favorites;

  void setReplayMode(ReplayMode mode, {int index}) {
    _replayMode = mode;

    notifyListeners();
    if(index != null) {
      _localStore.writeReplayModeIndex(index);
    }
  }



  Future getFavoritesFromDevice() async {
    try {
      final favoritesArray = _localStore.getFavorites();
      _favorites = Set.from(jsonDecode(favoritesArray));
    } catch (e) {
      await _localStore.writeFavorites(jsonEncode(List.from(_favorites)));
    }
  }

  void makeFavorite(int index, {MusicSource source}) {
    source ??= musicSource;
    final bool isFavorite = !collection[source][index].isFavorite;
    int id = collection[source][index].id;
    collection[source][index].isFavorite = isFavorite;

    isFavorite ? _favorites.add(id) : _favorites.remove(id);

    notifyListeners();
    _localStore.writeFavorites(jsonEncode(List.from(_favorites)));
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

        // TODO: This shouldn't be happening everytime the song changes
        // better when the app is about to stop
        _localStore.writeCurrentSongIndex(index);
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

  // Song get randomSong {
  //   Random random = Random();
  //   return _songs[random.nextInt(_songs.length)];
  // }
  int _sortSongByTitle(curr, next) {
    return curr.title.toLowerCase().compareTo(next.title.toLowerCase());
  }

  refresh() async {
    _songsLoading = true;
    final allSongs = await MusicFinder.allSongs();
    if (_favorites.length == 0) await getFavoritesFromDevice();
    _songs = allSongs
        .map<SimpleSong>((Song song) =>
            SimpleSong(song, isFavorite: _favorites.contains(song.id)))
        .toList()
          ..sort(_sortSongByTitle);

    collection[MusicSource.tracks] = _songs;
    _songsLoading = false;

    notifyListeners();

    // TODO: these shouldn't be happening everytime music refreshes
    try {
      currentSongIndex = _localStore.getCurrentSongIndex();
      final replayModeValues = ReplayMode.values;
      final replayMode = replayModeValues[_localStore.getReplayModeIndex()];
      setReplayMode(replayMode);
    } catch (e) {
      print('$e');
      setReplayMode(ReplayMode.none, index: 0);
    }
  }
}

enum ReplayMode {
  none,
  one,
  all,
}
enum PlayerState {
  stopped,
  playing,
  paused,
}
enum MusicSource {
  tracks,
  favorites,
}

class SimpleSong extends Song {
  // this class is an extension of the flute Song class
  // it enables us add an isFavorited field
  bool isFavorite;
  final Song song;
  SimpleSong(this.song, {this.isFavorite = false})
      : super(song.id, song.artist, song.title, song.album, song.albumId,
            song.duration, song.uri, song.albumArt);
}

class SongsCollection {
  final List<SimpleSong> songs;
  final String image;

  SongsCollection(this.songs, this.image);
}
