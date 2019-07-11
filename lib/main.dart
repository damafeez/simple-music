import 'package:flutter/material.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/widgets/navigation_logic.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<MusicEngine>(
          builder: (context) => MusicEngine()..refresh(),
        ),
      ],
      child: Application(),
    ));

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Music',
      theme: _buildThemeData(),
      home: NavigationLogic(),
    );
  }
}

ThemeData _buildThemeData() {
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
