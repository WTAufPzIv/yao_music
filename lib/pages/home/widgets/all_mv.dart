import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../components/music_cover.dart';
import '../../../constants/load_state.dart';
import '../../../models/mv_all.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/mv_all_provider.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';
import '../../mv_all/mv_all.dart';
import '../../mv_detail/mv_detail.dart';

class AllMv extends StatefulWidget {
  const AllMv({ super.key });

  @override
  State<AllMv> createState() => _AllMvState();
}

class _AllMvState extends State<AllMv> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 确保 context 安全
    Future.microtask(() {
      context.read<HomeProvider>().loadAllMv();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<HomeProvider>();
    bool loading = provider.loadAllMvLoadState == LoadState.loading;
    final List<MvModel> mv = provider.mv;

    final PageController controller = PageController(
      viewportFraction: 0.8,
    );

    return (
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: YMusicSpacing.xxl),
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
                            name: "/AllMvPage",
                          ),
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => MvAllProvider(),
                            child: MvAll(),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '热播影片',
                          style: YMusicTextStyles.title1,
                        ),
                        SizedBox(width: YMusicSpacing.xxs),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white.withOpacity(0.6),
                          size: 30,
                        ),
                      ],
                    )
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
                    height: 260,
                    child: PageView.builder(
                      controller: controller,
                      padEnds: false,
                      itemCount: mv.length,
                      itemBuilder: (context, index) {
                        return  _MvCoverCard(
                          mv: mv[index],
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

/*class NewAlbumReleaseFull extends StatefulWidget {
  const NewAlbumReleaseFull({ super.key });

  @override
  State<NewAlbumReleaseFull> createState() => _NewAlbumReleaseFullState();
}

class _NewAlbumReleaseFullState extends State<NewAlbumReleaseFull> {
  @override
  void initState() {
    super.initState();
    // 确保 context 安全
    Future.microtask(() {
      context.read<HomeProvider>().loadNewAlbumReleaseFull();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    bool loading = provider.loadNewAlbumReleaseStateFull == LoadState.loading;
    final List<NewAlbumReleaseModel> newAlbumFull = provider.newAlbumFull;
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
                    '新碟上架',
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
                              child: _MvCoverCard(
                                mv: newAlbumFull[index],
                                loading: loading,
                                isSimple: false,
                              )
                          )
                      );
                    },
                    childCount: newAlbumFull.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    /// 双列
                    crossAxisCount: 2,
                    /// 左右间距
                    crossAxisSpacing: YMusicSpacing.md,
                    /// 上下间距
                    mainAxisSpacing: YMusicSpacing.md,
                    /// 卡片宽高比例
                    childAspectRatio: 0.75,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}*/

class _MvCoverCard extends StatelessWidget {
  final MvModel mv;
  final bool loading;
  final bool isSimple;
  const _MvCoverCard({
    required this.mv,
    required this.loading,
    this.isSimple = true
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
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
                    name: "/MvDetail",
                  ),
                  builder: (_) => MVPlayerPage(
                    id: mv.id,
                    name: mv.name,
                    cover: mv.cover,
                    artistName: mv.artistName,
                    desc: mv.briefDesc
                  ),
                ),
              );
            },
            child: mv.cover!.startsWith('http') ? MusicCover(
              imageUrl: '${mv.cover}?param=600y600',
              width: isSimple ? 280 : 300,
              height: isSimple ? 200 : 180,
              radius: YMusicRadius.md,
            ): Image.asset(
              mv.cover,
              width: isSimple ? 280 : 300,
              height: isSimple ? 200 : 180,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: YMusicSpacing.md),
          /// 标题
          Padding(
            padding: EdgeInsets.only(
              right: isSimple ? YMusicSpacing.xl : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    mv.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: YMusicTextStyles.bodySmall
                ),
                SizedBox(height: YMusicSpacing.xs),
                Text(
                    mv.artistName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: YMusicTextStyles.caption
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}