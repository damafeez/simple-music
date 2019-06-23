import 'package:flutter/material.dart';
import 'package:simple_music_player/widgets/player_container.dart';
import 'package:simple_music_player/widgets/player_up_next.dart';

class Home extends StatelessWidget {
  final ScrollController scrollController;
  Home()
      : scrollController = ScrollController(),
        super();

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
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        padding: EdgeInsets.only(bottom: 0),
        children: <Widget>[
          SafeArea(bottom: false, child: PlayerContainer()),
          PlayerUpNext(
            onPlaylistTap: _onPlaylistTap,
          ),
        ],
      ),
    );
  }
}
