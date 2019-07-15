import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:simple_music_player/resources/utils.dart';

class MusicEngine extends ChangeNotifier {
  final MusicFinder _audioPlayer;

  bool _songsLoading = false;
  ReplayMode _replayMode = ReplayMode.none;
  int currentSongIndex = -1;
  int _currentSongId;
  PlayerState playerState = PlayerState.stopped;
  Set<int> _favorites = <int>{};
  PlayingFrom playingFrom = PlayingFrom.tracks;
  List<SimpleSong> _songs = <SimpleSong>[];
  LocalStore _localStore;

  MusicEngine()
      : _audioPlayer = MusicFinder(),
        _localStore = LocalStore() {
    _audioPlayer.setCompletionHandler(onComplete);
  }

  MusicFinder get audioPlayer => _audioPlayer;
  int get length => upNext().length;
  bool get songsLoading => _songsLoading;
  ReplayMode get replayMode => _replayMode;
  int get currentSongId => _currentSongId;

  List<SimpleSong> get tracks => _songs;
  List<SimpleSong> get favorites =>
      _songs.where((SimpleSong song) => song.isFavorite).toList();

  List<SimpleSong> upNext({PlayingFrom musicSource}) {
    musicSource ??= playingFrom;
    switch (musicSource) {
      case PlayingFrom.favorites:
        return favorites;

      case PlayingFrom.tracks:
      default:
        return tracks;
    }
  }

  SimpleSong findSongById(int id) {
    return _songs.firstWhere((SimpleSong song) => song.id == id);
  }

  SimpleSong get currentSong {
    if (_currentSongId != null) return findSongById(_currentSongId);
    return null;
  }

  void setCurrentSongId(int id) {
    _currentSongId = id;

    notifyListeners();
  }

  void setReplayMode(ReplayMode mode, {int index}) {
    _replayMode = mode;

    notifyListeners();
    if (index != null) {
      _localStore.writeReplayModeIndex(index);
    }
  }

  void switchReplayMode() {
    final values = ReplayMode.values;
    int currentIndex = values.indexOf(replayMode);
    int newIndex = currentIndex == values.length - 1 ? 0 : currentIndex + 1;
    final ReplayMode nextMode = values[newIndex];
    setReplayMode(nextMode, index: newIndex);
  }

  Future getFavoritesFromDevice() async {
    try {
      final favoritesArray = _localStore.getFavorites();
      _favorites = Set.from(jsonDecode(favoritesArray));
    } catch (e) {
      await _localStore.writeFavorites(jsonEncode(List.from(_favorites)));
    }
  }

  void makeFavorite(int index, {PlayingFrom source, bool isId = false}) {
    final SimpleSong song =
        isId ? findSongById(index) : upNext(musicSource: source)[index];
    song.isFavorite = !song.isFavorite;

    song.isFavorite ? _favorites.add(song.id) : _favorites.remove(song.id);
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

  Future playSong(int index,
      {PlayingFrom musicSource, bool shouldStop = true}) async {
    final song = upNext(musicSource: musicSource)[index];
    if (song != null) {
      if (shouldStop && playerState != PlayerState.stopped) {
        await stop();
      }
      final result = await _audioPlayer?.play(song?.uri, isLocal: true);

      if (result == 1) {
        playerState = PlayerState.playing;
        if (musicSource != null) playingFrom = musicSource;
        currentSongIndex = index;
        setCurrentSongId(song.id);

        notifyListeners();

        // TODO: This shouldn't be happening everytime the song changes
        // better when the app is about to stop
        final playingFromValues = PlayingFrom.values;
        final int playingFromIndex = playingFromValues.indexOf(playingFrom);
        _localStore.writeMusicSourceIndex(playingFromIndex);
        _localStore.writeCurrentSongIndex(index);
        // 
      } else {
        currentSongIndex = -1;
      }
    }
  }

  void play(int index, {PlayingFrom musicSource}) {
    if (index == currentSongIndex)
      playerState == PlayerState.playing
          ? pause()
          : playSong(index, musicSource: musicSource, shouldStop: false);
    else
      playSong(index, musicSource: musicSource);
  }

  Future pause() async {
    final result = await _audioPlayer?.pause();
    if (result == 1) {
      playerState = PlayerState.paused;

      notifyListeners();
    }
  }

  Future stop() async {
    final result = await _audioPlayer?.stop();
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

    _songsLoading = false;

    // TODO: these shouldn't be happening everytime music refreshes
    try {
      currentSongIndex = _localStore.getCurrentSongIndex();
      playingFrom = PlayingFrom.values[_localStore.getMusicSourceIndex()];
      final replayMode = ReplayMode.values[_localStore.getReplayModeIndex()];
      setReplayMode(replayMode);
      if (currentSongIndex >= 0)
        setCurrentSongId(upNext()[currentSongIndex].id);
    } catch (e) {
      print('$e');
      setReplayMode(ReplayMode.none, index: 0);
      currentSongIndex = -1;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: music state persistence should be done in persist
    // this method should be called when the app unmounts
    print('dispose was called=============');
    _localStore.writeCurrentSongIndex(currentSongIndex);

    final playingFromValues = PlayingFrom.values;
    final int playingFromIndex = playingFromValues.indexOf(playingFrom);
    _localStore.writeMusicSourceIndex(playingFromIndex);
    stop();

    super.dispose();
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
enum PlayingFrom {
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
