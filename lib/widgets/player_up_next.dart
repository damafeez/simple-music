import 'package:flutter/material.dart';
import 'package:simple_music_player/resources/assets.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';

class PlayerUpNext extends StatelessWidget {
  final onPlaylistTap;
  const PlayerUpNext({
    Key key,
    this.onPlaylistTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      padding: EdgeInsets.only(
        top: 10,
      ),
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
            Material(
              color: Colors.transparent,
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
                    onPressed: onPlaylistTap,
                    icon: Icon(
                      Icons.playlist_play,
                      color: secondaryText,
                    ),
                    iconSize: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                key: PageStorageKey<String>('Up Next'),
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpace.sm,
                ),
                itemBuilder: (BuildContext context, int index) => ListTile(
                      onTap: () => null,
                      leading: Container(
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
                              color: Color.fromRGBO(50, 50, 50, 0.3),
                              blurRadius: 10,
                              offset: Offset(1.0, 1.0),
                            )
                          ],
                        ),
                      ),
                      title: Text(
                        'Twentyone Pilots',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: secondaryText,
                          fontSize: AppFont.md - 3,
                        ),
                      ),
                      subtitle: Text(
                        'Honour and Us',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: AppFont.sm,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      trailing: Text(
                        '03:37',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          fontSize: AppFont.sm + 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
