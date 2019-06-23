import 'package:flutter/material.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/resources/colors.dart';

class PlayerTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpace.md),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('1:30',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                  )),
              Text('3:49',
                  style: TextStyle(
                    color: secondaryText,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          SizedBox(height: 5,),
          Stack(
            children: <Widget>[
              Container(
                height: 2.5,
                width: double.infinity,
                color: secondary,
              )
            ],
          ),
        ],
      ),
    );
  }
}
