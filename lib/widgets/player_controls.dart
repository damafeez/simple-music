import 'package:flutter/material.dart';

class PlayerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(child: Icon(Icons.favorite, size: 22,),onTap: () => null,),
          InkWell(child: Icon(Icons.skip_previous, size: 30.0,), onTap: () => null,),
          InkWell(child: Icon(Icons.play_arrow, size: 30.0,), onTap: () => null,),
          InkWell(child: Icon(Icons.skip_next, size: 30.0,), onTap: () => null,),
          InkWell(child: Icon(Icons.shuffle, size: 22.0,), onTap: () => null,),
        ],
      ),
    );
  }
}
