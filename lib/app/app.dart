import 'package:flutter/material.dart';
import '../pages/splash_page/splash_page.dart';
import '../utils/nav_obs.dart';

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// showPerformanceOverlay: true,
      title: 'YMusic',
      theme: ThemeData.dark(),
      /// home: MainPage(),
      home: SplashPage(),
      navigatorObservers: [
        AppRouteObserver()
      ],
    );
  }
}

