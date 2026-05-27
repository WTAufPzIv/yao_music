import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:yao_music/models/daily_recommend.dart';

import '../../../components/music_cover.dart';
import '../../../constants/load_state.dart';
import '../../../providers/home_provider.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';

class DailyRecommend extends StatefulWidget {
  const DailyRecommend({ super.key });

  @override
  State<DailyRecommend> createState() => _DailyRecommendState();
}

class _DailyRecommendState extends State<DailyRecommend> with AutomaticKeepAliveClientMixin {
  final PageController controller = PageController(
    viewportFraction: 0.9,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 确保 context 安全
    Future.microtask(() {
      context.read<HomeProvider>().loadDailyData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<HomeProvider>();
    bool loading = provider.loadBannerState == LoadState.loading;
    final List<DailyRecommendModel> daily = provider.daily;
    // 每页4个
    const int pageSize = 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: YMusicSpacing.xxxl),
        /// 标题
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: YMusicSpacing.lg,
          ),
          child: Text(
            '每日推荐',
            style: YMusicTextStyles.title1,
          ),
        ),
        const SizedBox(height: YMusicSpacing.md),
        Padding(
          padding: const EdgeInsets.only(
            left: YMusicSpacing.lg,
          ),
          child: Skeletonizer(
            enabled: loading,
            enableSwitchAnimation: true,
            child: SizedBox(
              height: 258,
              child: PageView.builder(
                controller: controller,
                padEnds: false,
                itemCount: loading ? 1 : 5,
                itemBuilder: (context, pageIndex) {
                  final start = pageIndex * pageSize;
                  final end = (start + pageSize).clamp(0, daily.length);
                  final pageSongs = daily.sublist(start, end);
                  return Padding(
                    padding:  const EdgeInsets.only(right: YMusicSpacing.sm),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(YMusicRadius.lg),
                      ),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pageSongs.length,
                        separatorBuilder: (_, __) => Divider(
                          color: Colors.white.withOpacity(0.10),
                          height: YMusicSpacing.lg,
                        ),
                        itemBuilder: (context, index) {
                          final song = pageSongs[index];
                          return _MusicItem(
                              song: song,
                              loading: loading,
                              openSongInfo: (DailyRecommendModel song) => provider.showSongInfoSheet(context, song)
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ),
      ]
    );
  }
}

class _MusicItem extends StatelessWidget {
  final DailyRecommendModel song;
  final bool loading;
  final Function(DailyRecommendModel song) openSongInfo;
  const _MusicItem({
    required this.song,
    required this.loading,
    required this.openSongInfo
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          // 左侧封面
          song.album.picUrl!.startsWith('http') ? MusicCover(
            imageUrl: '${song.album.picUrl}?param=100y100',
            width: 52,
            height: 52,
            radius: YMusicRadius.sm,
          ): Image.asset(
            song.album.picUrl,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),

          const SizedBox(width: YMusicSpacing.md),

          // 中间文字
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: YMusicTextStyles.songTitle
                ),
                const SizedBox(height: YMusicSpacing.xs),
                Text(
                  song.artistNames,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: YMusicTextStyles.artistName
                ),
              ],
            ),
          ),
          const SizedBox(width: YMusicSpacing.md),
          IconButton(onPressed: () {
            openSongInfo(song);
          }, icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ))
        ],
      ),
    );
  }
}