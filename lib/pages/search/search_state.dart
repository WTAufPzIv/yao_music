import 'package:flutter/material.dart';
import 'package:yao_music/pages/search/search_page.dart';
import '../../theme/app_color.dart';
import '../../theme/app_space.dart';
import '../../theme/app_text.dart';

class SearchPageState extends State<SearchPage> {
  String markPageName = '这是搜索';

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
                    '搜索',
                    style: YMusicTextStyles.largeTitle,
                  ),
                ),
              ],
            )
        )
    );
  }
}
