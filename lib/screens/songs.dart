import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/widgets/song_row.dart';

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: background,
              title: Text(
                'Songs',
                style: TextStyle(color: accentText),
              ),
              pinned: true,
              floating: true,
              forceElevated: true,
              bottom: TabBar(
                labelStyle: TextStyle(
                    fontSize: AppFont.sm, fontWeight: FontWeight.w700),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                labelColor: secondaryText,
                controller: tabController,
                indicatorColor: secondaryText,
                tabs: <Widget>[
                  Tab(
                    text: "Tracks",
                  ),
                  Tab(
                    text: "Playlist",
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            Tracks(),
            Playlists(),
          ],
          controller: tabController,
        ),
      ),
    );
  }
}

class Tracks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicEngine>(builder: (context, musicEngine, child) {
      if (musicEngine.songsLoading && musicEngine.tracks == null)
        return CircularProgressIndicator();
      return Scrollbar(
        child: SafeArea(
          top: false,
          bottom: false,
          child: ListView.builder(
              key: PageStorageKey<String>('Tracks'),
              itemCount: musicEngine.tracks.length,
              itemBuilder: (BuildContext context, int index) {
                final SimpleSong song = musicEngine.tracks[index];
                final bool isActive = musicEngine.currentSongId == song.id &&
                    musicEngine.playingFrom == PlayingFrom.tracks;
                return InkWell(
                  onTap: () {
                    isActive
                        ? musicEngine.toggleCurrentSong()
                        : musicEngine.playSong(song,
                            musicSource: PlayingFrom.tracks, index: index);
                  },
                  child: SongRow(
                    title: song.title,
                    number: index + 1,
                    artist: song.artist,
                    isActive: isActive,
                    isFavorite: song.isFavorite,
                    onFavoriteIconTap: () {
                      musicEngine.makeFavorite(index,
                          source: PlayingFrom.tracks);
                    },
                    isPlaying: musicEngine.playerState == PlayerState.playing,
                  ),
                );
              }),
        ),
      );
    });
  }
}

class Playlists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: ListView.builder(
        key: PageStorageKey<String>('Playlist'),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) => InkWell(
              onTap: () {},
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: AppSpace.md),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: AppSpace.sm,
                    ),
                    Text(
                      'New Playlist',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
