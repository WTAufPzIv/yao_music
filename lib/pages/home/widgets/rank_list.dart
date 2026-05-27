import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../components/music_cover.dart';
import '../../../constants/load_state.dart';
import '../../../models/new_album_release.dart';
import '../../../models/rank_list.dart';
import '../../../providers/home_provider.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';
import '../../set_list_detail/set_list_detail.dart';

class RankList extends StatefulWidget {
  const RankList({ super.key });

  @override
  State<RankList> createState() => _RankListState();
}

class _RankListState extends State<RankList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 确保 context 安全
    Future.microtask(() {
      context.read<HomeProvider>().loadRankList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<HomeProvider>();
    bool loading = provider.loadRankListState == LoadState.loading;
    final List<RankListModel> rank = provider.rank;

    final PageController controller = PageController(
      viewportFraction: 0.42,
    );

    return (
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: YMusicSpacing.xxxl),
            /// 标题
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: YMusicSpacing.lg,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '排行榜',
                      style: YMusicTextStyles.title1,
                    ),
                    SizedBox(width: YMusicSpacing.xxs)
                  ],
                )
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
                    height: 180,
                    child: PageView.builder(
                      controller: controller,
                      padEnds: false,
                      itemCount: rank.length,
                      itemBuilder: (context, index) {
                        return  _RankListCard(
                          rank: rank[index],
                          loading: loading,
                        );
                      },
                    ),
                  ),
                )
            ),
          ],
        )
    );
  }
}

class _RankListCard extends StatelessWidget {
  final RankListModel rank;
  final bool loading;
  const _RankListCard({
    required this.rank,
    required this.loading
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 封面
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SetListDetail(setListId: rank.id),
                ),
              );
            },
            child: rank.coverImgUrl!.startsWith('http') ? MusicCover(
              imageUrl: '${rank.coverImgUrl}?param=300y300',
              width: 150,
              height: 150,
              radius: YMusicRadius.md,
            ): Image.asset(
              rank.coverImgUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: YMusicSpacing.md)
        ],
      ),
    );
  }
}