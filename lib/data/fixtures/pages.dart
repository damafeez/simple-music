import 'package:flutter/material.dart';

final List<Page> pages = <Page>[
  Page(
    icon: Icon(Icons.home),
    label: 'Home',
    widget: Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    ),
  ),
  Page(
    icon: Icon(Icons.music_note),
    label: 'Songs',
    widget: Scaffold(
      body: Center(
        child: Text('Songs'),
      ),
    ),
  ),
  Page(
    icon: Icon(Icons.favorite),
    label: 'Favorites',
    widget: Scaffold(
      body: Center(
        child: Text('Favorites'),
      ),
    ),
  ),
  Page(
    icon: Icon(Icons.person),
    label: 'Artists',
    widget: Scaffold(
      body: Center(
        child: Text('Artists'),
      ),
    ),
  ),
  Page(
    icon: Icon(Icons.album),
    label: 'Albums',
    widget: Scaffold(
      body: Center(
        child: Text('Albums'),
      ),
    ),
  ),
];

class Page {
  final Widget widget;
  final Icon icon;
  final String label;

  Page({@required this.widget, @required this.icon, @required this.label});
}
