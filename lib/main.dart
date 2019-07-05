import 'package:flutter/material.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/screens/home.dart';

void main() => runApp(Application());

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Music',
      theme: _buildThemeData(),
      home: Home(),
    );
  }
}

ThemeData _buildThemeData () {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    accentColor: primary,
    iconTheme: base.iconTheme.copyWith(
      color: primary,
    ),
  );
}
