import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/constants/load_state.dart';

import '../../components/music_cover.dart';
import '../../models/artist_detail.dart';
import '../../providers/album_detail_provider.dart';
import '../../providers/artist_detail_provider.dart';
import '../../theme/app_color.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_space.dart';
import '../../theme/app_text.dart';
import '../album_detail/album_detail.dart';

class ArtistAlbumAll extends StatefulWidget {

  final int artistId;
  final String artistName;

  const ArtistAlbumAll({
    super.key,
    required this.artistId,
    required this.artistName,
  });

  @override
  State<ArtistAlbumAll> createState() => _ArtistAlbumAllState();
}
class _ArtistAlbumAllState extends State<ArtistAlbumAll> {
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  /// 上拉加载
  void _onScroll() {
    /// 距离底部300时开始预加载
    if (_controller.position.extentAfter < 300) {
      context.read<ArtistAllAlbumProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArtistAllAlbumProvider>();
    final list = provider.list;
    /// 首屏loading
    if (provider.loading == LoadState.loading &&
        list.isEmpty) {
      return const Scaffold(
        backgroundColor: YMusicColors.background,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    /// 错误状态
    if (provider.loading == LoadState.error &&
        list.isEmpty) {
      return Scaffold(
        backgroundColor: YMusicColors.background,
        body: Center(
          child: GestureDetector(
            onTap: provider.refresh,
            child: const Text(
              '加载失败，点击重试',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      );
    }
    /// 空状态
    if (provider.loading == LoadState.empty && list.isEmpty) {
      return const Scaffold(
        backgroundColor: YMusicColors.background,
        body: Center(
          child: Text(
            '暂无专辑',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: YMusicColors.background,
      body: CustomScrollView(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          /// 顶部导航栏
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
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
            title: Text(
              '${widget.artistName}的专辑',
              style: YMusicTextStyles.router,
            ),
          ),
          /// 网格区域
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: YMusicSpacing.lg,
              vertical: YMusicSpacing.md,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final album = list[index];
                  return _buildAlbumItem(album);
                },
                childCount: list.length,
              ),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                /// 双列
                crossAxisCount: 2,
                /// 左右间距
                crossAxisSpacing: YMusicSpacing.md,
                /// 上下间距
                mainAxisSpacing: YMusicSpacing.md,
                /// 卡片宽高比例
                childAspectRatio: 0.85,
              ),
            ),
          ),
          /// 底部loading
          SliverToBoxAdapter(
            child: _buildBottomLoader(provider),
          ),
          /// 底部安全距离
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  /// 专辑Item
  Widget _buildAlbumItem(
      AlbumOfArtistDetail album,
      ) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          /// 封面
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(
                    name: "/AlbumDetail",
                  ),
                  builder: (_) =>
                      ChangeNotifierProvider(
                        create: (_) => AlbumDetailProvider(),
                        child: AlbumDetail(
                          albumId: album.id,
                        ),
                      ),
                ),
              );
            },
            child: Hero(
              tag: 'album_${album.id}',
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(
                  YMusicRadius.md,
                ),
                child: album.picUrl != null &&
                    album.picUrl!
                        .startsWith('http')
                    ? MusicCover(
                  imageUrl:
                  '${album.picUrl}?param=300y300',
                  width: 180,
                  height: 180,
                  radius: YMusicRadius.md,
                )
                    : Image.asset(
                  album.picUrl ?? '',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: YMusicSpacing.sm,
          ),
          /// 标题
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: YMusicSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  album.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                  YMusicTextStyles.bodySmall,
                ),
                const SizedBox(
                  height: 2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 底部加载状态
  Widget _buildBottomLoader(
      ArtistAllAlbumProvider provider,
      ) {
    /// 首屏空数据
    if (provider.list.isEmpty) {
      return const SizedBox.shrink();
    }
    /// 正在加载更多
    if (provider.loading ==
        LoadState.loading &&
        provider.more) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }
    /// 没有更多
    if (!provider.more) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Center(
          child: Text(
            '没有更多了',
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

