import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../components/music_cover.dart';
import '../../../constants/load_state.dart';
import '../../../models/rank_list.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/set_list_provider.dart';
import '../../../theme/app_color.dart';
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(
                          name: "/RankListFull",
                        ),
                        builder: (_) => const RankListFull(),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '排行榜',
                        style: YMusicTextStyles.title1,
                      ),
                      SizedBox(width: YMusicSpacing.xxs),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withOpacity(0.6),
                        size: 30,
                      ),
                    ],
                  ),
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

class RankListFull extends StatefulWidget {
  const RankListFull({super.key});

  @override
  State<RankListFull> createState() => _RankListFullState();
}

class _RankListFullState extends State<RankListFull> {
  @override
  void initState() {
    super.initState();
    // 确保 context 安全
    Future.microtask(() {
      context.read<HomeProvider>().loadRankListFull();
    });
  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    bool loading = provider.loadRankListState == LoadState.loading;
    final List<RankListModel> rankFull = provider.rankFull;
    return (
        Scaffold(
          backgroundColor: YMusicColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                /// 是否固定顶部
                pinned: true,
                /// 展开高度
                expandedHeight: 0,
                /// 毛玻璃效果
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 20,
                      sigmaY: 20,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.65),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: YMusicColors.primary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: false,
                title: const Text(
                    '排行榜',
                    style: YMusicTextStyles.router
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: YMusicSpacing.lg,
                    vertical: YMusicSpacing.md
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Skeletonizer(
                          enabled: loading,
                          enableSwitchAnimation: true,
                          child: Center(
                              child: _RankListCard(
                                rank: rankFull[index],
                                loading: loading,
                                isSimple: false
                              )
                          )
                      );
                    },
                    childCount: loading ? 8 : rankFull.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    /// 双列
                    crossAxisCount: 2,
                    /// 左右间距
                    crossAxisSpacing: YMusicSpacing.md,
                    /// 上下间距
                    mainAxisSpacing: YMusicSpacing.xxs,
                    /// 卡片宽高比例
                    childAspectRatio: 0.91,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}

class _RankListCard extends StatelessWidget {
  final RankListModel rank;
  final bool loading;
  final bool isSimple;
  const _RankListCard({
    required this.rank,
    required this.loading,
    this.isSimple = true
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isSimple ? 150 : 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 封面
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(
                    name: "/SetListDetail",
                  ),
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => SetListProvider(),
                    child: SetListDetail(
                        setListId: rank.id
                    ),
                  ),
                ),
              );
            },
            child: rank.coverImgUrl!.startsWith('http') ? MusicCover(
              imageUrl: '${rank.coverImgUrl}?param=300y300',
              width: isSimple ? 150 : 180,
              height: isSimple ? 150 : 180,
              radius: YMusicRadius.md,
            ): Image.asset(
              rank.coverImgUrl,
              width: isSimple ? 150 : 180,
              height: isSimple ? 150 : 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: YMusicSpacing.md)
        ],
      ),
    );
  }
}