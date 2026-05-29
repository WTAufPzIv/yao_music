import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/providers/home_provider.dart';
import 'package:yao_music/providers/login_provider.dart';
import 'package:yao_music/providers/song_detail_provider.dart';
import 'api/base/dio_http.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHttp.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SongDetailProvider(),
        ),
      ],
      child: const MyApp(),
    )
  );
}
