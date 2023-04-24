import 'dart:convert';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit_config.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class VideoUtil {
  static const String subtitleFile = "subtitle.srt";

  static Future<File> writeStringToFile(
      String strContent, String fileName) async {
    List<int> bytes = utf8.encode(strContent);

    final String fullTemporaryPath = join((await tempDirectory).path, fileName);

    Future<File> fileFuture = File(fullTemporaryPath)
        .writeAsBytes(bytes, mode: FileMode.writeOnly, flush: true);

    return fileFuture;
  }

  static void registerApplicationFonts() {
    var fontNameMapping = <String, String>{};
    fontNameMapping["MyFontName"] = "Arial";
    VideoUtil.tempDirectory.then((tempDirectory) {
      FFmpegKitConfig.setFontDirectoryList(
          [tempDirectory.path, "/system/fonts", "/System/Library/Fonts"],
          fontNameMapping);
    });
  }

  static Future<String> getResourcePath(String resourceName) async {
    return join((await tempDirectory).path, resourceName);
  }

  static Future<Directory> get documentsDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  static Future<Directory> get tempDirectory async {
    return await getTemporaryDirectory();
  }

  static String generateSubtitles(
      List<String> sentences, double averageReadingSpeed) {
    double secondsPerWord = 60 / averageReadingSpeed;
    String srt = "";
    int index = 1;
    double startTime = 0;

    for (String sentence in sentences) {
      int wordCount = sentence.split(" ").length;
      double duration = wordCount * secondsPerWord;
      double endTime = startTime + duration;

      srt += "$index\n";
      srt += "${formatTime(startTime)} --> ${formatTime(endTime)}\n";
      //srt += "{\\an5}$sentence\n\n"; //Middle-center
      srt += "$sentence\n\n";
      index++;
      startTime = endTime;
    }
    return srt;
  }

  static String formatTime(double time) {
    int hours = (time ~/ 3600);
    int minutes = ((time ~/ 60) % 60);
    int seconds = (time % 60).toInt();
    int milliseconds = ((time % 1) * 1000).toInt();
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')},${milliseconds.toString().padLeft(3, '0')}";
  }
}
