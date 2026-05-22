import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/providers/home_provider.dart';
import 'app/app.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => HomeProvider(),
      )
    ],
    child: const MyApp(),
  )
);