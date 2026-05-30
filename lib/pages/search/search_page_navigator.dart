import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yao_music/pages/search/search_wrapper.dart';

class SearchNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const SearchNavigator({
    super.key,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const SearchPageWrapper(),
        );
      },
    );
  }
}