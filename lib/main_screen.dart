import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suvigen/routes.dart';

import 'named_navigation_bar_item_widget.dart';

class MainScreen extends StatelessWidget {
  final Widget screen;

  MainScreen({Key? key, required this.screen}) : super(key: key);

  final tabs = [
    NamedNavigationBarItemWidget(
      initialLocation: Routes.speechTextSyncScreen,
      icon: const Icon(Icons.headphones),
      label: 'Speech text sync',
    ),
    NamedNavigationBarItemWidget(
      initialLocation: Routes.subtitleGenerationScreen,
      icon: const Icon(Icons.subtitles),
      label: 'Generation of video subtitles',
    ),
    NamedNavigationBarItemWidget(
      initialLocation: Routes.concatenateVideosScreen,
      icon: const Icon(Icons.file_copy),
      label: 'Generation of video subtitles',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen,
      bottomNavigationBar: _buildBottomNavigation(context, tabs),
    );
  }

  Widget _buildBottomNavigation(
      context, List<NamedNavigationBarItemWidget> tabs) {
    return BottomNavigationBar(
      onTap: (value) {
        GoRouter.of(context).go(tabs[value].initialLocation);
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 1,
      selectedIconTheme: IconThemeData(
        size: ((IconTheme.of(context).size)! * 1.2),
      ),
      items: tabs,
      type: BottomNavigationBarType.fixed,
    );
  }
}
