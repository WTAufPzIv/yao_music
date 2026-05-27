import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/providers/album_detail_provider.dart';
import 'package:yao_music/providers/artist_detail_provider.dart';
import 'package:yao_music/providers/home_provider.dart';
import 'package:yao_music/providers/set_list_provider.dart';
import 'app/app.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => HomeProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => SetListProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AlbumDetailProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ArtistDetailProvider(),
      )
    ],
    child: const MyApp(),
  )
);