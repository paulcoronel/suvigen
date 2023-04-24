import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart';
import 'package:suvigen/suvigen_screen.dart';
import 'package:suvigen/video_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SuvigenApp());
}

class SuvigenApp extends StatelessWidget {
  const SuvigenApp({super.key});

  @override
  Widget build(BuildContext context) {
    FFmpegKitConfig.init().then((_) {
      VideoUtil.registerApplicationFonts();
      //initialize your resources
    });

    return MaterialApp(
      title: 'Suvigen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SuvigenScreen(),
    );
  }
}
