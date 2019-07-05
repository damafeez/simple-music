import 'dart:async';
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
  StreamController closeMusicContainer;
  double panPercent = 0.0;

  _HomeState() : closeMusicContainer = StreamController();

  _onPlaylistTap() {
    final double scrollBottom = scrollController.position.maxScrollExtent;
    final double scrollTop = scrollController.position.minScrollExtent;

    scrollController.animateTo(
      scrollController.offset == scrollBottom ? scrollTop : scrollBottom,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  _onPanUpdate(double panPercentValue) {
    setState(() {
      panPercent = panPercentValue;
    });
  }

  _onPanEnd() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future((){
        if (panPercent == 1.0) {
          return true;
        } else {
          closeMusicContainer.add('close');
        }
      }),
      child: Stack(
        children: <Widget>[
          Scaffold(
            body: Container(
              color: Colors.red,
            ),
          ),
          Transform.translate(
            offset: Offset(
                0.0, ((MediaQuery.of(context).size.height - 100) * panPercent)),
            child: Scaffold(
              body: ListView(
                physics: NeverScrollableScrollPhysics(),
                controller: scrollController,
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  PlayerContainer(
                    panPercent: panPercent,
                    panUpdateCallback: _onPanUpdate,
                    panEndCallback: _onPanEnd,
                    closeStreamController: closeMusicContainer,
                  ),
                  PlayerUpNext(
                    onPlaylistTap: _onPlaylistTap,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
