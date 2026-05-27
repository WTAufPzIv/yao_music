import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/theme/app_color.dart';
import 'package:yao_music/theme/app_text.dart';

import '../../components/music_cover.dart';
import '../../constants/load_state.dart';
import '../../models/set_list_detail.dart';
import '../../providers/set_list_provider.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_space.dart';

class SetListDetail extends StatefulWidget {
  final int setListId;
  const SetListDetail({ super.key, required this.setListId });

  @override
  State<SetListDetail> createState() => _SetListDetailState();
}

class _SetListDetailState extends State<SetListDetail> {
  final ScrollController _scrollController = ScrollController();
  /// 滚动距离
  double scrollOffset = 0;
  /// 顶部标题动画进度
  double get collapseProgress {
    print(scrollOffset);
    if (scrollOffset <= 300) return 0;
    final progress = ((scrollOffset - 300) / 60).clamp(0.0, 1.0);
    return progress;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<SetListProvider>().loadSetListDetailData(widget.setListId);
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
    final Color bgColor = provider.bgColor;
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
              expandedHeight: 520,
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
                        width: 520,
                        height: 520,
                        httpHeaders: { "user-agent": 'windows' },
                        fit: BoxFit.cover,
                      ),
                      /// 渐变遮罩
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              bgColor.withOpacity(0.05),
                              bgColor.withOpacity(0.25),
                              bgColor.withOpacity(1),
                              bgColor,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// 标题
                            Text(
                              detail.name ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: YMusicTextStyles.title3,
                            ),
                            const SizedBox(height: YMusicSpacing.sm),
                            Text(
                              detail.description ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: YMusicTextStyles.body,
                            ),
                            const SizedBox(height: YMusicSpacing.md),
                            SizedBox(
                              width: 200,
                              child: _actionButton(
                                icon:
                                Icons.play_arrow_rounded,
                                text: '播放',
                              ),
                            ),
                            SizedBox(
                              height: YMusicSpacing.lg,
                            )
                          ],
                        )
                      ),
                      /// 顶部标题栏（滚动后浮现）
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            color: bgColor.withOpacity(collapseProgress),
                            child: Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).padding.top),
                                SizedBox(
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
                              ],
                            )
                        ),
                      ),
                    ],
                  );
                },
              )
            ),
            SliverList.builder(
              itemCount: detail.songs?.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _setListSongItem(song: detail.songs![index], index: index),
                    if (index != detail.songs.length - 1)
                      const Divider(
                        height: 1,
                        indent: YMusicSpacing.lg,
                        endIndent: 16,
                        color: Colors.white12,
                      ) else
                      const SizedBox(
                        height: YMusicSpacing.xxxl,
                      )
                  ],
                );
              },
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

  Widget _setListSongItem({
    required SetListDetailSongsModel song,
    required int index,
  }) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: YMusicSpacing.lg,
        vertical: YMusicSpacing.sm,
      ),
      child: Row(
        children: [
          MusicCover(
            imageUrl: '${song.album.picUrl}?param=100y100',
            width: 52,
            height: 52,
            radius: YMusicRadius.sm,
          ),
          SizedBox(width: YMusicSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                /// 歌曲名称
                Text(
                  song.name ?? '',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: YMusicTextStyles.bodyLarge
                ),
                const SizedBox(height: YMusicSpacing.xxs),
                /// 歌手名称
                Text(
                  song.artistNames ?? '',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: YMusicTextStyles.bodySmall
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          /// 更多按钮
          Icon(
            Icons.more_horiz_rounded,
            color: Colors.white
                .withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}