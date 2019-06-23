import 'package:flutter/material.dart';
import 'package:simple_music_player/resources/sizes.dart';

class PlayerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpace.sm - 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(icon: Icon(Icons.favorite, size: 22,),onPressed: () => null,),
          IconButton(icon: Icon(Icons.skip_previous, size: 30.0,), onPressed: () => null,),
          IconButton(icon: Icon(Icons.play_arrow, size: 30.0,), onPressed: () => null,),
          IconButton(icon: Icon(Icons.skip_next, size: 30.0,), onPressed: () => null,),
          IconButton(icon: Icon(Icons.shuffle, size: 22.0,), onPressed: () => null,),
        ],
      ),
    );
  }
}
