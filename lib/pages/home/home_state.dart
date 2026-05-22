import 'package:flutter/material.dart';
import 'package:yao_music/pages/home/widgets/new_discover.dart';
import '../../theme/app_color.dart';
import '../../theme/app_space.dart';
import 'home_page.dart';

class HomePageState extends State<HomePage> {
  String markPageName = '这是首页';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: YMusicColors.background,
      body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: YMusicSpacing.xl,
            ),
            children: [
              const NewDiscover()
            ],
          )
      )
    );
  }
}
