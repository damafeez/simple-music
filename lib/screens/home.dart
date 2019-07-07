import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_music_player/data/fixtures/pages.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/widgets/player_container.dart';
import 'package:simple_music_player/widgets/player_up_next.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollController = ScrollController();
  StreamController closeMusicContainer;
  double panPercent = 1.0;
  int bottomNavigationIndex = 1;
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

  _buildBottomBarItems() {
    List<BottomNavigationBarItem> bottomNavigationBarItems =
        <BottomNavigationBarItem>[];

    for (int i = 0; i < pages.length; i++) {
      final Page page = pages[i];
      bottomNavigationBarItems.add(BottomNavigationBarItem(
          icon: page.icon,
          title: Text(page.label,
              style: i == bottomNavigationIndex
                  ? TextStyle(fontWeight: FontWeight.w600)
                  : null)));
    }
    return bottomNavigationBarItems;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future(() {
            if (panPercent == 1.0) {
              return true;
            } else {
              closeMusicContainer.add('close');
            }
          }),
      child: Stack(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7 * (1 - panPercent)),
            ),
            position: DecorationPosition.foreground,
            child: Container(
              padding: EdgeInsets.only(bottom: 120),
              child: pages.elementAt(bottomNavigationIndex).widget,
            ),
          ),
          Transform.translate(
            offset: Offset(
                0.0, ((MediaQuery.of(context).size.height - 120) * panPercent)),
            child: Scaffold(
              body: ListView(
                physics: ClampingScrollPhysics(),
                controller: scrollController,
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  PlayerContainer(
                    panPercent: panPercent,
                    panUpdateCallback: _onPanUpdate,
                    scaffoldScrollController: scrollController,
                    closeStreamController: closeMusicContainer,
                  ),
                  PlayerUpNext(
                    onPlaylistTap: _onPlaylistTap,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Transform.translate(
              offset: Offset(0.0, 100.0 * (1 - panPercent)),
              child: Opacity(
                opacity: ((panPercent * 2) - 1).clamp(0.0, 1.0),
                child: BottomNavigationBar(
                  unselectedItemColor: secondaryText,
                  selectedItemColor: primaryText,
                  showUnselectedLabels: true,
                  selectedFontSize: 12,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: bottomNavigationIndex,
                  onTap: (int index) => setState(() {
                        bottomNavigationIndex = index;
                      }),
                  items: _buildBottomBarItems(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
