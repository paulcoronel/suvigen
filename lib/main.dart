import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart';
import 'package:suvigen/video_util.dart';
import 'app_router.dart';

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
    return MaterialApp.router(
      title: 'Suvigen',
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
    );
  }
}
