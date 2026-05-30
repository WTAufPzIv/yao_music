import 'package:flutter/cupertino.dart';

class TabNavigatorObserver extends NavigatorObserver {
  final ValueNotifier<bool> showBottomBar;

  TabNavigatorObserver(this.showBottomBar);

  void _update() {
    showBottomBar.value =
        navigator?.canPop() == false;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _update();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _update();
  }
}