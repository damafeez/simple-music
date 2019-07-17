import 'package:flutter/material.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/resources/utils.dart';

class UpNextRow extends StatelessWidget {
  final String title;
  final String artist;
  final Duration duration;
  final bool isActive;
  final bool isPlaying;
  final Function onTap;
  final String albumArt;
  const UpNextRow({
    Key key,
    @required this.title,
    @required this.artist,
    @required this.duration,
    this.isActive = false,
    this.isPlaying = false,
    this.onTap,
    this.albumArt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap,
      leading: Container(
        height: 47,
        width: 47,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: buildAlbumArt(albumArt),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(3.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(50, 50, 50, 0.2),
              blurRadius: 5,
              offset: Offset(1.0, 1.0),
            )
          ],
        ),
      ),
      title: Text(
        '${truncate(title, 20)}',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: secondaryText,
          fontSize: AppFont.md - 4,
        ),
      ),
      subtitle: Text(
        '${truncate(artist, 30)}',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: AppFont.sm,
          color: Colors.grey,
          height: 1.5,
        ),
      ),
      trailing: Text(
        formatDuration(duration),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          fontSize: AppFont.sm + 1,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
    );
  }
}
