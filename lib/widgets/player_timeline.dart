import 'package:flutter/material.dart';
import 'package:simple_music_player/data/store/music_engine.dart';
import 'package:simple_music_player/resources/sizes.dart';
import 'package:simple_music_player/resources/colors.dart';

class PlayerTimeline extends StatefulWidget {
  final MusicEngine musicEngine;

  const PlayerTimeline({Key key, this.musicEngine}) : super(key: key);

  @override
  _PlayerTimelineState createState() => _PlayerTimelineState();
}

class _PlayerTimelineState extends State<PlayerTimeline> {
  double seekValue = 0;
  bool isSeeking = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpace.md),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${widget.musicEngine.positionText}',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                  )),
              Text('${widget.musicEngine.durationText}',
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
              value: isSeeking
                  ? seekValue
                  : (widget.musicEngine.duration.inSeconds == 0
                      ? 0
                      : (widget.musicEngine.position.inSeconds /
                              widget.musicEngine.duration.inSeconds)
                          .clamp(0.0, 1.0)),
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
