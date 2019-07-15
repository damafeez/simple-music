import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  SharedPreferences prefs;
  final String favoritesKey = 'favorites';
  final String currentSong = 'current_song_index';
  final String replayMode = 'replay_mode_index';

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
}

String truncate(String string, int length) {
    final _string = string.replaceAll(RegExp('\n'), ' ');
    final truncated =
        '${_string.substring(0, length > _string.length ? _string.length : length).trim()}...';
    return _string.length <= truncated.length ? _string : truncated;
}
