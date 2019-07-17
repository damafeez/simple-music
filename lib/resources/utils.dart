import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  SharedPreferences prefs;
  final String favoritesKey = 'favorites';
  final String currentSong = 'current_song_index';
  final String replayMode = 'replay_mode_index';
  final String playingFrom = 'playing_from_index';

  LocalStore() {
    SharedPreferences.getInstance().then((instance) {
      prefs = instance;
    });
  }

  String getFavorites() {
    return prefs.getString(favoritesKey) ?? '[]';
  }

  Future<bool> writeFavorites(String favorites) {
    return prefs.setString(favoritesKey, favorites);
  }

  int getCurrentSongIndex() {
    return prefs.getInt(currentSong) ?? -1;
  }

  Future<bool> writeCurrentSongIndex(int index) {
    return prefs.setInt(currentSong, index);
  }

  int getReplayModeIndex() {
    return prefs.getInt(replayMode) ?? 0;
  }

  Future<bool> writeReplayModeIndex(int index) {
    return prefs.setInt(replayMode, index);
  }

  int getMusicSourceIndex() {
    return prefs.getInt(playingFrom) ?? 0;
  }

  Future<bool> writeMusicSourceIndex(int index) {
    return prefs.setInt(playingFrom, index);
  }
}

String truncate(String string, int length) {
  final _string = string.replaceAll(RegExp('\n'), ' ');
  final truncated =
      '${_string.substring(0, length > _string.length ? _string.length : length).trim()}...';
  return _string.length <= truncated.length ? _string : truncated;
}

String formatDuration(Duration duration) {
  if (duration == null) return '';
  final int hours = duration.inHours;
  final int minutes = duration.inMinutes % 60;
  final int seconds = duration.inSeconds % 60;

  final _hours = hours > 0 ? '$hours:' : '';
  final _seconds = seconds > 9 ? '$seconds' : '0$seconds';

  return '$_hours$minutes:$_seconds';
}
