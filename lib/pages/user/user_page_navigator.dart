import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yao_music/pages/user/user_page.dart';

class UserNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const UserNavigator({
    super.key,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const UserPage(),
        );
      },
    );
  }
}