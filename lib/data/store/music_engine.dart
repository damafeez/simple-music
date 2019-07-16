import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:simple_music_player/resources/utils.dart';

class MusicEngine extends ChangeNotifier {
  final MusicFinder _audioPlayer;

  bool _songsLoading = false;
  ReplayMode _replayMode = ReplayMode.none;
  int _currentSongIndex = -1;
  PlayerState _playerState = PlayerState.stopped;
  int _currentSongId;
  Set<int> _favorites = <int>{};
  PlayingFrom _playingFrom = PlayingFrom.tracks;
  List<SimpleSong> _songs = <SimpleSong>[];
  LocalStore _localStore;

  MusicEngine()
      : _audioPlayer = MusicFinder(),
        _localStore = LocalStore() {
    _audioPlayer.setCompletionHandler(onComplete);
  }

  PlayingFrom get playingFrom => _playingFrom;
  PlayerState get playerState => _playerState;
  MusicFinder get audioPlayer => _audioPlayer;
  int get length => upNext().length;
  bool get songsLoading => _songsLoading;
  ReplayMode get replayMode => _replayMode;
  int get currentSongIndex => _currentSongIndex;
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

  SimpleSong getSongByIndex(int index, {PlayingFrom musicSource}) {
    try {
      return upNext(musicSource: musicSource)[index];
    } catch (e) {
      return null;
    }
  }

  SimpleSong getSongById(int id) {
    return _songs.firstWhere((SimpleSong song) => song.id == id);
  }

  SimpleSong get currentSong {
    if (_currentSongId != null) return getSongById(_currentSongId);
    return null;
  }

  void setCurrentSongId(int id) {
    _currentSongId = id;

    notifyListeners();
  }

  void setPlayerState(PlayerState state) {
    _playerState = state;

    notifyListeners();
  }

  void setCurrentSongIndex(int index) {
    index ??= -1;
    _currentSongIndex = index;

    notifyListeners();
    // TODO: REFACTOR: shouldn't write everytime
    // index changes
    _localStore.writeCurrentSongIndex(index);
  }

  void setPlayingFrom(PlayingFrom musicSource) {
    _playingFrom = musicSource;

    notifyListeners();
    // TODO: REFACTOR: shouldn't write everytime
    // musicSource changes
    final int index = PlayingFrom.values.indexOf(musicSource);
    _localStore.writeMusicSourceIndex(index);
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
        isId ? getSongById(index) : upNext(musicSource: source)[index];
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
        return play(currentSong);
      case ReplayMode.all:
        if (currentSongIndex == length - 1) {
          return playSong(getSongByIndex(0), index: 0);
        }
        return playNextSong();
      default:
    }
  }

  Future playNextSong() {
    if (currentSongIndex < length - 1) {
      int index = currentSongIndex + 1;
      return playSong(getSongByIndex(index), index: index);
    }
  }

  Future playPrevSong() {
    if (currentSongIndex > 0) {
      int index = currentSongIndex - 1;
      return playSong(getSongByIndex(index), index: index);
    }
  }

  Future<int> play(SimpleSong song, {bool shouldStop = true}) async {
    if (shouldStop && playerState != PlayerState.stopped) {
      await stop();
    }
    if (song == null) return 0;
    final result = await _audioPlayer?.play(song?.uri, isLocal: true);

    if (result == 1) {
      setPlayerState(PlayerState.playing);
    }
    return result;
  }

  void toggleCurrentSong() {
    playerState == PlayerState.playing
        ? pause()
        : play(currentSong, shouldStop: false);
  }

  Future<int> playSong(SimpleSong song,
      {PlayingFrom musicSource, int index}) async {
    final result = await play(song);
    if (result == 1) {
      if (musicSource != null) setPlayingFrom(musicSource);
      if (index != null) setCurrentSongIndex(index);
      setCurrentSongId(song.id);
    } else {
      setCurrentSongIndex(-1);
    }
    return result;
  }

  Future pause() async {
    final result = await _audioPlayer?.pause();
    if (result == 1) {
      setPlayerState(PlayerState.paused);
    }
  }

  Future stop() async {
    final result = await _audioPlayer?.stop();
    if (result == 1) {
      setPlayerState(PlayerState.stopped);
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
    notifyListeners();

    // TODO: these shouldn't be happening everytime music refreshes
    try {
      setCurrentSongIndex(_localStore.getCurrentSongIndex());
      setPlayingFrom(PlayingFrom.values[_localStore.getMusicSourceIndex()]);
      setReplayMode(ReplayMode.values[_localStore.getReplayModeIndex()]);
      if (currentSongIndex >= 0)
        setCurrentSongId(upNext()[currentSongIndex].id);
    } catch (e) {
      print('$e');
      setReplayMode(ReplayMode.none, index: 0);
      setCurrentSongIndex(-1);
    }
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
