
import 'package:go_router/go_router.dart';
import 'package:suvigen/concatenate_videos_screen.dart';
import 'package:suvigen/routes.dart';
import 'package:suvigen/speech_text_sync_screen.dart';
import 'package:suvigen/subtitle_generation_screen.dart';

import 'main_screen.dart';
import 'not_found_screen.dart';

class AppRouter {
  //static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  //static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.speechTextSyncScreen,
    debugLogDiagnostics: true,
    //navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        //navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(screen: child);
        },
        routes: [
          GoRoute(
              path: Routes.speechTextSyncScreen,
              builder: (context, state) => const SpeechTextSyncScreen()),
          GoRoute(
              path: Routes.speechTextSyncScreen,
              builder: (context, state) => const SpeechTextSyncScreen()),
          GoRoute(
              path: Routes.subtitleGenerationScreen,
              builder: (context, state) => const SubtitleGenerationScreen()),
          GoRoute(
              path: Routes.concatenateVideosScreen,
              builder: (context, state) => const ConcatenateVideosScreen())
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );

  static GoRouter get router => _router;
}
