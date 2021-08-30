import 'package:clip/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:video_player/video_player.dart';
import 'dart:html' as html;

class Lecture1 extends StatefulWidget {
  const Lecture1({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _Lecture1State createState() => _Lecture1State();
}

class _Lecture1State extends State<Lecture1> {
  late VideoPlayerController _controller;

  //

  //
  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/bumble_bee_captions.srt');
    return SubRipCaptionFile(fileContents);
  }

  //
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      // 'https://vsu.play.kakao.com/vod/vcfe5In0dB00BP7B5aa005b/mp4/mp4_720P_2M_T1/clip.mp4?px-time=1628506206&px-bps=5687617&px-bufahead=12&px-hash=c5ea3cdd4c489563c5489e3bc59b4da5',
      'http://vod.kmoocs.kr/vod/2017/01/05/a4c4e175-91b9-432e-a77c-3cb688222338.mp4?1629173947768',
      closedCaptionFile: _loadCaptions(),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String test = "on";
  String x = "0";
  String y = "0";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: AspectRatio(
            aspectRatio: 1.0,
            // aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                ClosedCaption(text: _controller.value.caption.text),
                // _ControlsOverlay(controller: _controller),
                VideoProgressIndicator(_controller, allowScrubbing: true),
                GestureDetector(

                  onHorizontalDragStart: (detail) {
                    x = detail.globalPosition.dx.toString();
                    y = detail.globalPosition.dy.toString();
                    HCILocation()
                        .getScreen(x, y, widget.uid, "lecture", "screen")
                        .then((value) {
                      setState(() {
                        print("a");
                      });
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Text(
                      "",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    controller.play();
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
              ),
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     controller.value.isPlaying ? controller.pause() : controller.play();
        //   },
        // ),

      ],
    );
  }
}
