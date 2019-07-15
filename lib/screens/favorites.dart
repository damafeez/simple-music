import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/widgets/song_row.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: background,
              title: Text(
                'Favorites',
                style: TextStyle(color: accentText),
              ),
              floating: true,
              pinned: true,
              forceElevated: true,
            ),
          ];
        },
        body: Consumer<MusicEngine>(builder: (context, musicEngine, child) {
          if (musicEngine.songsLoading) return CircularProgressIndicator();
          return Scrollbar(
            child: SafeArea(
              top: false,
              bottom: false,
              child: ListView.builder(
                itemCount: musicEngine.favorites.length,
                itemBuilder: (BuildContext context, int index) => InkWell(
                      key: PageStorageKey<int>(musicEngine.favorites[index].id),
                      onTap: () {
                        musicEngine.play(index,
                            musicSource: PlayingFrom.favorites);
                      },
                      child: SongRow(
                        title: musicEngine.favorites[index].title,
                        number: index + 1,
                        artist: musicEngine.favorites[index].artist,
                        isActive: musicEngine.currentSongId ==
                                musicEngine.favorites[index].id &&
                            musicEngine.playingFrom == PlayingFrom.favorites,
                        onFavoriteIconTap: () {
                          musicEngine.makeFavorite(index,
                              source: PlayingFrom.favorites);
                        },
                        isPlaying:
                            musicEngine.playerState == PlayerState.playing,
                      ),
                    ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
