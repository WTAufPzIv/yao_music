import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/constants/load_state.dart';

import '../../components/music_cover.dart';
import '../../models/mv_all.dart';
import '../../providers/mv_all_provider.dart';
import '../../theme/app_color.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_space.dart';
import '../../theme/app_text.dart';
import '../mv_detail/mv_detail.dart';

class MvAll extends StatefulWidget {
  const MvAll({super.key});

  @override
  State<MvAll> createState() => _MvAllState();
}

class _MvAllState extends State<MvAll> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<MvAllProvider>();
      provider.changeOrder(MvAllOrderType.hot);
      _controller.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 距离底部 300px 时开始预加载下一页
    if (_controller.position.extentAfter < 300) {
      context.read<MvAllProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MvAllProvider>();
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
    /// 空状态
    if (provider.loading == LoadState.empty && list.isEmpty) {
      return const Scaffold(
        backgroundColor: YMusicColors.background,
        body: Center(
          child: Text(
            '暂无数据',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
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
              '所有MV',
              style: YMusicTextStyles.router,
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSortBar(provider),
          ),
          /// 网格区域
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: YMusicSpacing.sm,
              vertical: YMusicSpacing.md,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final mv = list[index];
                  return _MvCoverCard(mv: mv, loading: false);
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
                childAspectRatio: 1.05,
              ),
            ),
          ),
          /// 底部loading
          SliverToBoxAdapter(
            child: _buildBottomLoader(provider),
          ),
          /// 底部安全距离
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortBar(MvAllProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _sortChip(
              label: '上升最快',
              selected: provider.order == MvAllOrderType.up,
              onTap: () => provider.changeOrder(MvAllOrderType.up)
          ),
          const SizedBox(width: 12),
          _sortChip(
              label: '最热',
              selected: provider.order == MvAllOrderType.hot,
              onTap: () => provider.changeOrder(MvAllOrderType.hot)
          ),
          const SizedBox(width: 12),
          _sortChip(
              label: '最新',
              selected: provider.order == MvAllOrderType.newest,
              onTap: () => provider.changeOrder(MvAllOrderType.newest)
          ),
        ],
      ),
    );
  }

  Widget _sortChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white12,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomLoader(MvAllProvider provider) {
    if (provider.list.isEmpty) return const SizedBox.shrink();

    if (provider.more) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          '没有更多了',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}

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
      width: 200,
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
              width: isSimple ? 200 : 300,
              height: isSimple ? 120 : 180,
              radius: YMusicRadius.md,
            ): Image.asset(
              mv.cover,
              width: isSimple ? 200 : 300,
              height: isSimple ? 120 : 180,
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

