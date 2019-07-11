import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/data/fixtures/pages.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/screens/player.dart';

class NavigationLogic extends StatefulWidget {
  @override
  _NavigationLogicState createState() => _NavigationLogicState();
}

class _NavigationLogicState extends State<NavigationLogic> {
  final bottomBar = GlobalKey();

  double bottomBarHeight = 55.0;
  StreamController<NavigationLogicEvents> navigationLogicEvents;
  double panPercent = 1.0;
  int bottomNavigationIndex = 1;
  _NavigationLogicState() : navigationLogicEvents = StreamController();

  _updatePanPercent(double panPercentValue) {
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
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        bottomBarHeight = bottomBar.currentContext?.size?.height;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicEngine>(builder: (context, musicEngine, child) {
      final collapsedPlayerHeight =
          collapsedAlbumArtWidth + collapsedAlbulmArtHorizontalPadding;
      final bottomPadding = musicEngine.currentSongIndex < 0
          ? bottomBarHeight
          : collapsedPlayerHeight + bottomBarHeight;
      return WillPopScope(
        onWillPop: () => Future(() {
              if (panPercent == 1.0) {
                return true;
              } else {
                navigationLogicEvents.add(NavigationLogicEvents.collapsePlayer);
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
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: pages.elementAt(bottomNavigationIndex).widget,
              ),
            ),
            Transform.translate(
              offset: Offset(
                  0.0,
                  ((MediaQuery.of(context).size.height - bottomPadding) *
                      panPercent)),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Player(
                  panPercent: panPercent,
                  onPanUpdate: _updatePanPercent,
                  navigationLogicEvents: navigationLogicEvents,
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
                    key: bottomBar,
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
    });
  }
}

enum NavigationLogicEvents {
  collapsePlayer,
}
