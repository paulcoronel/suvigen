import 'dart:io';

import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_video/log.dart';
import 'package:ffmpeg_kit_flutter_video/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:suvigen/util.dart';
import 'package:suvigen/video_player_widget.dart';
import 'package:suvigen/video_util.dart';

import 'constant.dart';

class ConcatenateVideosScreen extends StatefulWidget {
  const ConcatenateVideosScreen({super.key});

  @override
  ConcatenateVideosScreenState createState() => ConcatenateVideosScreenState();
}

class ConcatenateVideosScreenState extends State<ConcatenateVideosScreen> {
  bool isLoading = false;
  VideoPlayerWidget? videoPlayerWidget;

  @override
  void initState() {
    FFmpegKitConfig.enableLogCallback(logCallback);
    super.initState();
  }

  void logCallback(Log log) {
    if (kDebugMode) {
      print(log.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {
    getConcatenatedVideoPath().then((path) => VideoPlayerWidget(File(path)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Concatenate videos'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  concatenateVideosFromAssets(context, ["cascada.mp4","leon.mp4","anemonas.mp4"]);
                },
                child: const Text('Concatenate videos'),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator()
              else if (videoPlayerWidget != null)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Merged Video:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    videoPlayerWidget!
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> concatenateVideosFromAssets(
      BuildContext context, List<String> videoNames) async {
    setState(() {
      isLoading = true;
    });

    _loadVideos(videoNames).then((videos) {
      getConcatenatedVideoFile().then((concatenatedVideo) {
        deleteFile(concatenatedVideo);
        concatenateVideos(videos, concatenatedVideo);
      });
    });
  }

  void playVideo(File concatenatedVideo) {
    isLoading = false;
    videoPlayerWidget = VideoPlayerWidget(concatenatedVideo);
    videoPlayerWidget!.playVideo().then((value) => setState(() {}));
  }

  void concatenateVideos(List<File> videos, File concatenatedVideo) async {
    int loop = 2;
    String inputArgs = videos.map((file) => ' -i ${file.path}').join(" ");
    StringBuffer arguments = StringBuffer();
    arguments.writeAll(List.generate(loop, (_) => inputArgs));

    final concatenateVideoCommand =
        ' ${arguments.toString()} -r 50 -filter_complex "concat=n=${videos.length * loop}" -c:v mpeg4  ${concatenatedVideo.path}';

    FFmpegKit.executeAsync(concatenateVideoCommand, (session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        print("Completed");
        playVideo(concatenatedVideo);
      }
    });
  }

  Future<File> getConcatenatedVideoFile() async {
    return File("${Constant.downloadsPath}/${Constant.concatenatedVideoName}");
  }

  Future<List<File>> _loadVideos(List<String> videoNames) async {
    List<File> videos = [];

    for (var videoName in videoNames) {
      videos.add(await VideoUtil.copyAssetToFile(videoName));
    }
    return videos;
  }

  Future<String> getConcatenatedVideoPath() async {
    return join(
        (await VideoUtil.tempDirectory).path, Constant.concatenatedVideoName);
  }
}
