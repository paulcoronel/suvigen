import 'dart:io';
import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_video/log.dart';
import 'package:ffmpeg_kit_flutter_video/return_code.dart';
import 'package:ffmpeg_kit_flutter_video/session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:suvigen/constant.dart';
import 'package:suvigen/util.dart';
import 'package:suvigen/video_util.dart';
import 'package:video_player/video_player.dart';

class SubtitleGenerationScreen extends StatefulWidget {
  const SubtitleGenerationScreen({Key? key}) : super(key: key);

  @override
  SubtitleGenerationState createState() => SubtitleGenerationState();
}

enum VideoCreationState { notStarted, creatingVideo, addingSubtitles, complete }

class SubtitleGenerationState extends State<SubtitleGenerationScreen> {
  VideoCreationState _videoCreationState = VideoCreationState.notStarted;
  VideoPlayerController? _videoPlayerController;
  File? outputFile;

  @override
  void initState() {
    serVideoPlayerController();
    FFmpegKitConfig.enableLogCallback(logCallback);
    super.initState();
  }

  void logCallback(Log log) {
    if (kDebugMode) {
      print(log.getMessage());
    }
  }

  void serVideoPlayerController() {
    getVideoWithSubtitlesFile().then(
        (file) => _videoPlayerController = VideoPlayerController.file(file));
  }

  @override
  void dispose() {
    super.dispose();
  }

  late int? _sessionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate subtitles on a Video')
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _videoCreationState ==
                          VideoCreationState.creatingVideo ||
                      _videoCreationState == VideoCreationState.addingSubtitles
                  ? null
                  : () async {
                      setState(() {
                        _videoCreationState = VideoCreationState.creatingVideo;
                        _generateVideo();
                      });
                    },
              child: _videoCreationState == VideoCreationState.creatingVideo ||
                      _videoCreationState == VideoCreationState.addingSubtitles
                  ? const CircularProgressIndicator()
                  : const Text('Generate video with subtitles'),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 480,
              width: 640,
              child: FutureBuilder<bool>(
                future: Future.value(_videoPlayerController != null
                    ? _videoPlayerController!.value.isInitialized
                    : false),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == true) {
                    return Container(
                      alignment: const Alignment(0.0, 0.0),
                      child: VideoPlayer(_videoPlayerController!),
                    );
                  } else {
                    return Container(
                        alignment: const Alignment(0.0, 0.0),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(236, 240, 241, 1.0),
                            border: Border.all(
                              color: const Color.fromRGBO(185, 195, 199, 1.0),
                              width: 1.0,
                            )));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _generateVideo() async {
    List<String> sentences = Constant.originalText;
    String subtitles =
        VideoUtil.generateSubtitles(sentences, Constant.averageReadingSpeed);

    await VideoUtil.writeStringToFile(subtitles, VideoUtil.subtitleFile)
        .then((value) {
      VideoUtil.getResourcePath(VideoUtil.subtitleFile).then((subtitlePath) {
        getVideoFile().then((videoFile) {
          getVideoWithSubtitlesFile().then((videoWithSubtitlesFile) {
            deleteFile(videoFile);
            deleteFile(videoWithSubtitlesFile);
            String blankVideoCommand =
                '-f lavfi -i color=c=black:s=640x480:d=35 -filter_complex  [0:v]setpts=PTS-STARTPTS[video] -map [video] -vsync 2 -async 1  ${videoFile.path}';

            FFmpegKit.executeAsync(blankVideoCommand, (session) async {
              final returnCode = await session.getReturnCode();
              if (ReturnCode.isSuccess(returnCode)) {
                String burnSubtitlesCommand =
                    "-y -i ${videoFile.path} -vf subtitles=$subtitlePath:force_style='FontSize=20' -c:v mpeg4 ${videoWithSubtitlesFile.path}";
                _videoCreationState = VideoCreationState.addingSubtitles;
                FFmpegKit.executeAsync(burnSubtitlesCommand,
                    (Session secondSession) async {
                  final secondReturnCode = await secondSession.getReturnCode();

                  if (ReturnCode.isSuccess(secondReturnCode)) {
                    _videoCreationState = VideoCreationState.complete;
                    playVideo().then((value) => setState(() {}));
                  }
                }).then((session) => _sessionId = session.getSessionId());
              }
            }).then((session) {
              //_sessionId = session.getSessionId();
              //print("SessionId ${session.getSessionId()}.");
            });
          });
        });
      });
    });
  }

  Future<File> getVideoFile() async {
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    return File("${documentsDirectory.path}/${Constant.generatedVideoName}");
  }

  Future<File> getVideoWithSubtitlesFile() async {
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    return File("${documentsDirectory.path}/${Constant.subtitledVideoName}");
  }

  Future<void> playVideo() async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.play();
    }
  }
}
