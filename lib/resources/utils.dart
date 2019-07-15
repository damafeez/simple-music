import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  SharedPreferences prefs;
  final String favoritesKey = 'favorites';

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
}

String truncate(String string, int length) {
    final _string = string.replaceAll(RegExp('\n'), ' ');
    final truncated =
        '${_string.substring(0, length > _string.length ? _string.length : length).trim()}...';
    return _string.length <= truncated.length ? _string : truncated;
}
