class Lyrics {
  Lyrics(text) : formattedLyrics = text.split('\n');

  int activeIndex = 0;
  final List<String> formattedLyrics;
}
