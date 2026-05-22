import 'package:flutter/material.dart';
import '../pages/main/main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YMusic',
      theme: ThemeData.dark(),
      home: MainPage(),
    );
  }
}

