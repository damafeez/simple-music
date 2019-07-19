import 'package:flutter/material.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/resources/colors.dart';
import 'package:simple_music_player/resources/utils.dart';

class PlayerTimeline extends StatefulWidget {
  final MusicEngine musicEngine;

  const PlayerTimeline({Key key, this.musicEngine}) : super(key: key);

  @override
  _PlayerTimelineState createState() => _PlayerTimelineState();
}

class _PlayerTimelineState extends State<PlayerTimeline> {
  double seekValue = 0;
  bool isSeeking = false;

  Duration get duration => widget.musicEngine.duration;
  Duration get position {
    return isSeeking
        ? Duration(seconds: (seekValue * duration.inSeconds).toInt())
        : widget.musicEngine.position;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpace.md),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${formatDuration(position)}',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                  )),
              Text('${formatDuration(duration)}',
                  style: TextStyle(
                    color: secondaryText,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: secondaryText,
              inactiveTrackColor: secondary,
              trackHeight: 2.5,
              thumbColor: primary,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3.0),
              overlayColor: secondaryText.withOpacity(0.5),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0),
            ),
            child: Slider(
              value: duration.inSeconds == 0
                  ? 0
                  : (position.inSeconds / duration.inSeconds).clamp(0.0, 1.0),
              onChanged: (double value) {
                setState(() {
                  seekValue = value;
                });
              },
              onChangeStart: (_) {
                setState(() {
                  isSeeking = true;
                });
              },
              onChangeEnd: (double value) {
                widget.musicEngine.seek(value);
                setState(() {
                  isSeeking = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
