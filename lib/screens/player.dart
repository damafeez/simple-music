import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/widgets/navigation_logic.dart';
import 'package:simple_music_player/widgets/player_container.dart';
import 'package:simple_music_player/widgets/player_up_next.dart';

class Player extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final double panPercent;
  final Function onPanUpdate;
  final StreamController<NavigationLogicEvents> navigationLogicEvents;

  Player({Key key, this.panPercent, this.onPanUpdate, this.navigationLogicEvents})
      : super(key: key);

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
    return Consumer<MusicEngine>(
      builder: (context, musicEngine, child) {
        return Scaffold(
          body: musicEngine.currentSongIndex < 0 ? Container() : ListView(
            controller: scrollController,
            padding: EdgeInsets.all(0.0),
            children: <Widget>[
              PlayerContainer(
                PlayerContainerViewModel(
                  panPercent: panPercent,
                  panUpdateCallback: onPanUpdate,
                  scaffoldScrollController: scrollController,
                  navigationLogicEvents: navigationLogicEvents,
                  musicEngine: musicEngine,
                ),
              ),
              PlayerUpNext(
                onPlaylistTap: _onPlaylistTap,
              ),
            ],
          ),
        );
      },
    );
  }
}
