import 'package:flutter/material.dart';
import 'package:simple_music_player/screens/albums.dart';
import 'package:simple_music_player/screens/artists.dart';
import 'package:simple_music_player/screens/favorites.dart';
import 'package:simple_music_player/screens/home.dart';
import 'package:simple_music_player/screens/songs.dart';

final List<Page> pages = <Page>[
  Page(
    icon: Icon(Icons.home),
    label: 'Home',
    widget: Home(),
  ),
  Page(
    icon: Icon(Icons.music_note),
    label: 'Songs',
    widget: Songs(),
  ),
  Page(
    icon: Icon(Icons.favorite),
    label: 'Favorites',
    widget: Favorites(),
  ),
  // Page(
  //   icon: Icon(Icons.person),
  //   label: 'Artists',
  //   widget: Artists(),
  // ),
  // Page(
  //   icon: Icon(Icons.album),
  //   label: 'Albums',
  //   widget: Albums(),
  // ),
];

class Page {
  final Widget widget;
  final Icon icon;
  final String label;

  Page({@required this.widget, @required this.icon, @required this.label});
}
