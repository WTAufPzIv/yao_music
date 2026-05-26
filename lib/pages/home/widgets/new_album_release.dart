import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../components/music_cover.dart';
import '../../../constants/load_state.dart';
import '../../../models/new_album_release.dart';
import '../../../providers/home_provider.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';

class NewAlbumRelease extends StatefulWidget {
  const NewAlbumRelease({ super.key });

  @override
  State<NewAlbumRelease> createState() => _NewAlbumReleaseState();
}

class _NewAlbumReleaseState extends State<NewAlbumRelease> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 确保 context 安全
    Future.microtask(() {
      context.read<HomeProvider>().loadNewAlbumRelease();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<HomeProvider>();
    bool loading = provider.loadNewAlbumReleaseState == LoadState.loading;
    final List<NewAlbumReleaseModel> newAlbumRelease = provider.newAlbum;

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
                        builder: (_) => const NewAlbumReleaseFull(),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '新碟上架',
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
                  height: 202,
                  child: PageView.builder(
                    controller: controller,
                    padEnds: false,
                    itemCount: newAlbumRelease.length,
                    itemBuilder: (context, index) {
                      return  _NewAlbumReleaseCard(
                        album: newAlbumRelease[index],
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

class NewAlbumReleaseFull extends StatefulWidget {
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
                              child: _NewAlbumReleaseCard(
                                album: newAlbumFull[index],
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
}

class _NewAlbumReleaseCard extends StatelessWidget {
  final NewAlbumReleaseModel album;
  final bool loading;
  final bool isSimple;
  const _NewAlbumReleaseCard({
    required this.album,
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
          album.picUrl!.startsWith('http') ? MusicCover(
            imageUrl: '${album.picUrl}?param=300y300',
            width: isSimple ? 150 : 180,
            height: isSimple ? 150 : 180,
            radius: YMusicRadius.md,
          ): Image.asset(
            album.picUrl,
            width: isSimple ? 150 : 180,
            height: isSimple ? 150 : 180,
            fit: BoxFit.cover,
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
                    album.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: YMusicTextStyles.bodySmall
                ),
                SizedBox(height: YMusicSpacing.xs),
                Text(
                    album.artistNames,
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