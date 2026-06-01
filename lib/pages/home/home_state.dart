import 'package:flutter/material.dart';
import 'package:yao_music/pages/home/widgets/daily_recommend.dart';
import 'package:yao_music/pages/home/widgets/hot_top.dart';
import 'package:yao_music/pages/home/widgets/new_album_release.dart';
import 'package:yao_music/pages/home/widgets/new_discover.dart';
import 'package:yao_music/pages/home/widgets/personalized_set_list.dart';
import 'package:yao_music/pages/home/widgets/rank_list.dart';
import '../../theme/app_color.dart';
import '../../theme/app_space.dart';
import '../../theme/app_text.dart';
import 'home_page.dart';

class HomePageState extends State<HomePage> {
  String markPageName = '这是首页';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YMusicColors.background,
      body: SafeArea(
          child: ListView(
            addAutomaticKeepAlives: true,
            padding: const EdgeInsets.symmetric(
              vertical: YMusicSpacing.xl,
            ),
            children: [
              /// 标题
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: YMusicSpacing.lg,
                  vertical: YMusicSpacing.lg,
                ),
                child: Text(
                  '主页',
                  style: YMusicTextStyles.largeTitle,
                ),
              ),
              const NewDiscover(),
              const DailyRecommend(),
              const PersonalizedSetList(),
              const NewAlbumRelease(),
              const HotTop(),
              const RankList(),
              const SizedBox(
                height: 30,
              )
            ],
          )
      )
    );
  }
}
