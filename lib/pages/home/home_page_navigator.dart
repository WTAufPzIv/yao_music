import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yao_music/pages/home/home_wrapper.dart';

class HomeNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const HomeNavigator({
    super.key,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const HomePageWrapper(),
        );
      },
    );
  }
}