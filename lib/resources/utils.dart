class Utils {
  static String truncate(String string, int length) {
    final _string = string.replaceAll(RegExp('\n'), ' ');
    final truncated =
        '${_string.substring(0, length > _string.length ? _string.length : length).trim()}...';
    return _string.length <= truncated.length ? _string : truncated;
  }
}
