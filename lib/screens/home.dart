import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_music_player/widgets/player_container.dart';
import 'package:simple_music_player/widgets/player_up_next.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollController = ScrollController();
  double panPercent = 0.0;

  _onPlaylistTap() {
    final double scrollBottom = scrollController.position.maxScrollExtent;
    final double scrollTop = scrollController.position.minScrollExtent;

    scrollController.animateTo(
      scrollController.offset == scrollBottom ? scrollTop : scrollBottom,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Container(
            color: Colors.red,
          ),
        ),
        Transform.translate(
          offset: Offset(0.0, lerpDouble(0, MediaQuery.of(context).size.height - 100, panPercent)),
          child: Scaffold(
            body: ListView(
              physics: ClampingScrollPhysics(),
              controller: scrollController,
              padding: EdgeInsets.only(bottom: 0),
              children: <Widget>[
                PlayerContainer(panPercent: panPercent),
                PlayerUpNext(
                  onPlaylistTap: _onPlaylistTap,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
