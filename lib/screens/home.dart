import 'package:flutter/material.dart';
import 'package:simple_music_player/widgets/player_container.dart';
import 'package:simple_music_player/widgets/player_up_next.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(child: PlayerContainer()),
            PlayerUpNext(),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:simple_music_player/widgets/player_container.dart';
// import 'package:simple_music_player/widgets/player_up_next.dart';

// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: CustomScrollView(slivers: <Widget>[
//       SliverToBoxAdapter(
//         child: SafeArea(child: PlayerContainer()),
//       ),
//       SliverToBoxAdapter(child: PlayerUpNext()),
//     ]));
//   }
// }
