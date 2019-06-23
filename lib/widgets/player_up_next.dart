import 'package:flutter/material.dart';
import 'package:simple_music_player/resources/assets.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';

class PlayerUpNext extends StatelessWidget {
  const PlayerUpNext({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpace.sm),
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
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Up Next',
                style: TextStyle(
                    color: secondaryText,
                    fontWeight: FontWeight.w600),
              ),
              Icon(Icons.playlist_play, size: 25,)
            ],
          ),
          SafeArea(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) => Row(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage(SIA),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(3.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(50, 50, 50, 0.4),
                              blurRadius: 2,
                              offset: Offset(1.0, 1.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
