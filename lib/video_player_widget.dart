import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  late final File _file;
  late final VideoPlayerController _videoPlayerController;
  final bool startedPlaying = false;

  VideoPlayerWidget(this._file, {super.key}) {
    _videoPlayerController = VideoPlayerController.file(_file);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: FutureBuilder<bool>(
              future: Future.value(_videoPlayerController!.value.isInitialized),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.data == true) {
                  return Container(
                    height: 360,
                    width: 640,
                    alignment: const Alignment(0.0, 0.0),
                    child: VideoPlayer(_videoPlayerController!),
                  );
                } else {
                  return Container(
                      alignment: const Alignment(0.0, 0.0),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 0, 241, 1.0),
                          border: Border.all(
                            color: const Color.fromRGBO(185, 195, 199, 1.0),
                            width: 1.0,
                          )));
                }
              },
            ),
          ),
        ));
  }

  Future<void> playVideo() async {
    await _videoPlayerController!.initialize();
    await _videoPlayerController!.play();
  }
}
