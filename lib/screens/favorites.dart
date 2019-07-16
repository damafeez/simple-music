import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/assets.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/widgets/song_row.dart';

import "package:flare_flutter/flare_actor.dart";

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Favorites',
            style: TextStyle(color: accentText),
          ),
          backgroundColor: background,
        ),
        body: Stack(
          children: <Widget>[
            Container(
                child: FlareActor(
              HEART_FLARE,
              alignment: Alignment.center,
              fit: BoxFit.contain,
              color: secondary.withOpacity(0.5),
              animation: 'bubble heart',
            )),
            Consumer<MusicEngine>(builder: (context, musicEngine, child) {
              if (musicEngine.songsLoading) return CircularProgressIndicator();
              return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: AppSpace.sm),
                  physics: BouncingScrollPhysics(),
                  itemCount: musicEngine.favorites.length,
                  itemBuilder: (BuildContext context, int index) {
                    final SimpleSong song = musicEngine.favorites[index];
                    return InkWell(
                      key: PageStorageKey<int>(song.id),
                      onTap: () {
                        musicEngine.playSong(song,
                            musicSource: PlayingFrom.favorites, index: index);
                      },
                      child: SongRow(
                        title: song.title,
                        number: index + 1,
                        artist: song.artist,
                        isActive: musicEngine.currentSongId ==
                                song.id &&
                            musicEngine.playingFrom == PlayingFrom.favorites,
                        onFavoriteIconTap: () {
                          musicEngine.makeFavorite(index,
                              source: PlayingFrom.favorites);
                        },
                        isPlaying:
                            musicEngine.playerState == PlayerState.playing,
                      ),
                    );
                  });
            }),
          ],
        ));
  }
}
