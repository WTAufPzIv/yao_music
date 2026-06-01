import 'package:flutter/cupertino.dart';
import 'package:yao_music/components/mini_player.dart';

import '../components/overlay.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class RouteManager {
  static String currentRoute = "/";
}

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _refreshMiniPlayer() {
    MiniPlayerOverlay.refresh();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    print('didPush: ${route.settings.name}');
    RouteManager.currentRoute = route.settings.name ?? "";
    _refreshMiniPlayer();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('didPop: ${previousRoute?.settings.name}');
    RouteManager.currentRoute = previousRoute?.settings.name ?? "";
    _refreshMiniPlayer();
  }
}