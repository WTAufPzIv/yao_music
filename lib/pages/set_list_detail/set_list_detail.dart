import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/theme/app_color.dart';
import 'package:yao_music/theme/app_text.dart';

import '../../constants/load_state.dart';
import '../../models/set_list_detail.dart';
import '../../providers/set_list_provider.dart';
import '../../theme/app_space.dart';

class SetListDetail extends StatefulWidget {
  final int setListId;
  const SetListDetail({ super.key, required this.setListId });

  @override
  State<SetListDetail> createState() => _SetListDetailState();
}

class _SetListDetailState extends State<SetListDetail> {
  final ScrollController _scrollController = ScrollController();
  /// 页面背景色
  Color bgColor = YMusicColors.background;
  /// 滚动距离
  double scrollOffset = 0;

  /// 提取封面主色
  Future<void> updateBgColor(String imageUrl) async {
    try {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
        maximumColorCount: 20,
      );

      final color = paletteGenerator.dominantColor?.color;

      if (color != null && mounted) {
        setState(() {
          /// 压暗一点，更像 Apple Music
          bgColor = Color.lerp(color, Colors.black, 0.35)!;
        });
      }
    } catch (_) {}
  }

  /// 顶部标题动画进度
  double get collapseProgress {
    final progress = (scrollOffset / 160).clamp(0.0, 1.0);
    return progress;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SetListProvider>().loadSetListDetailData(widget.setListId);
    });
    /// 监听滚动
    _scrollController.addListener(() {
      setState(() {
        scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SetListProvider>();
    bool loading = provider.loadState == LoadState.loading;
    final SetListDetailModel detail = provider.detail;
    /// 数据加载完成后提取颜色
    if (!loading && detail.coverImgUrl != null && detail.coverImgUrl!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateBgColor(detail.coverImgUrl!);
      });
    }
    return Scaffold(
      backgroundColor: bgColor,
      body: loading ? const Center(
        child: CupertinoActivityIndicator(),
      ) : AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: bgColor,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              expandedHeight: 400,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      /// 背景封面
                      CachedNetworkImage(
                        imageUrl: detail.coverImgUrl,
                        width: 300,
                        height: 300,
                        httpHeaders: { "user-agent": 'windows' },
                        fit: BoxFit.cover,
                      ),
                      /// 毛玻璃
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 0,
                          sigmaY: 0,
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ),
                      /// 渐变遮罩
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.15),
                              Colors.black.withOpacity(0.45),
                              bgColor,
                            ],
                          ),
                        ),
                      ),
                      /// 顶部标题栏（滚动后浮现）
                      Positioned(
                        top: MediaQuery.of(context).padding.top,
                        left: 12,
                        right: 12,
                        child: SizedBox(
                          height: kToolbarHeight,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: YMusicColors.primary,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(width: YMusicSpacing.md),
                              Expanded(
                                child: Opacity(
                                  opacity: collapseProgress,
                                  child: Transform.translate(
                                    offset: Offset(
                                      0,
                                      20 * (1 - collapseProgress),
                                    ),
                                    child: Text(
                                      detail.name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /// 大图区域
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: 0,
                        child: Column(
                          children: [
                            /// 标题
                            Text(
                              detail.name ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: YMusicTextStyles.title3,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:  const EdgeInsets.symmetric(
                  horizontal: YMusicSpacing.xl,
                  // vertical: YMusicSpacing.sm,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: YMusicSpacing.md),                      Text(
                        detail.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: YMusicTextStyles.bodySmall,
                      ),
                      const SizedBox(height: YMusicSpacing.md),
                      SizedBox(
                        width: 200,
                        child: _actionButton(
                          icon:
                          Icons.play_arrow_rounded,
                          text: '播放',
                        ),
                      )
                    ],
                  )
                )
              )
            )
          ],
        ),
      )
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String text,
  }) {
    return Container(
      height: 46,

      decoration: BoxDecoration(

        /// 半透明背景
        color: Colors.white.withOpacity(0.1),

        borderRadius:
        BorderRadius.circular(999),

        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),

      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),

          const SizedBox(width: 6),

          Text(
            text,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}