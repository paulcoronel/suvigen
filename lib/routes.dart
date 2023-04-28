import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'not_found_screen.dart';

class Routes {
  //static const root = '/';
  static const concatenateVideosScreen = '/concatenateVideosScreen';
  static const subtitleGenerationScreen = '/subtitleGenerationScreen';
  static const speechTextSyncScreen = '/speechTextSyncScreen';

  static Widget errorWidget(BuildContext context, GoRouterState state) =>
      const NotFoundScreen();
}
