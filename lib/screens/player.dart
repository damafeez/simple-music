import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/data/store/app_state.dart';
import 'package:simple_music_player/widgets/player_container.dart';
import 'package:simple_music_player/widgets/player_up_next.dart';

class Player extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final double panPercent;
  final Function onPanUpdate;
  final StreamController closeMusicContainer;

  Player({Key key, this.panPercent, this.onPanUpdate, this.closeMusicContainer})
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
    return Consumer<AppState>(
      builder: (context, model, child) {
        return Scaffold(
          body: ListView(
            physics: ClampingScrollPhysics(),
            controller: scrollController,
            padding: EdgeInsets.all(0.0),
            children: <Widget>[
              PlayerContainer(
                panPercent: panPercent,
                panUpdateCallback: onPanUpdate,
                scaffoldScrollController: scrollController,
                closeStreamController: closeMusicContainer,
                model: model,
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
