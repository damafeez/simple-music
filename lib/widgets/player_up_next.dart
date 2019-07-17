import 'package:flutter/material.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/widgets/upnext_row.dart';

class PlayerUpNext extends StatelessWidget {
  final Function onPlaylistTap;
  final MusicEngine musicEngine;
  const PlayerUpNext({
    Key key,
    this.onPlaylistTap,
    this.musicEngine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(5, 5, 5, 0.1),
            blurRadius: 60,
            offset: Offset(0, -5.0),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: onPlaylistTap,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: AppSpace.sm,
                    ),
                    Text(
                      'Up Next',
                      style: TextStyle(
                          color: secondaryText, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.shuffle,
                      ),
                      color: secondaryText,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount:
                      musicEngine.length - (musicEngine.currentSongIndex + 1) >
                              20
                          ? 20
                          : musicEngine.length - (musicEngine.currentSongIndex + 1),
                  key: PageStorageKey<String>('Up Next'),
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpace.sm,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    SimpleSong song = musicEngine
                        .upNext()[index + musicEngine.currentSongIndex + 1];
                    return UpNextRow(
                      title: song.title,
                      artist: song.artist,
                      albumArt: song.albumArt,
                      duration: Duration(milliseconds: song.duration),
                      onTap: () {},
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
