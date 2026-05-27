import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/theme/app_color.dart';
import 'package:yao_music/theme/app_text.dart';

import '../../components/music_cover.dart';
import '../../constants/load_state.dart';
import '../../models/album_detail.dart';
import '../../models/set_list_detail.dart';
import '../../providers/album_detail_provider.dart';
import '../../providers/set_list_provider.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_space.dart';

class AlbumDetail extends StatefulWidget {
  final int albumId;
  const AlbumDetail({ super.key, required this.albumId });

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  final ScrollController _scrollController = ScrollController();
  /// 滚动距离
  double scrollOffset = 0;
  /// 顶部标题动画进度
  double get collapseProgress {
    if (scrollOffset <= 300) return 0;
    final progress = ((scrollOffset - 300) / 60).clamp(0.0, 1.0);
    return progress;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<AlbumDetailProvider>().loadAlbumDetailData(widget.albumId);
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
    final provider = context.watch<AlbumDetailProvider>();
    bool loading = provider.loadState == LoadState.loading;
    final AlbumDetailModel detail = provider.detail;
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
                            imageUrl: detail.picUrl,
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
                                  bgColor.withOpacity(0.80),
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
                                  Container(
                                    width: 250,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.35),
                                          blurRadius: 30,
                                          offset: const Offset(0, 15),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(16),
                                      child: Image.network(
                                        detail.picUrl ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  /// 标题
                                  Text(
                                    detail.name ?? '',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: YMusicTextStyles.title3,
                                  ),
                                  Text(
                                    detail.artistNames ?? '',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: YMusicTextStyles.title3.copyWith(color: YMusicTextStyles.title3.color?.withOpacity(0.5)),
                                  ),
                                  const SizedBox(height: YMusicSpacing.sm),
                                  GestureDetector(
                                    onTap: () {
                                      provider.showDescriptionSheet(
                                          context,
                                          detail
                                      );
                                    },
                                    child: Text(
                                      detail.description ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: YMusicTextStyles.body,
                                    ),
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
                itemCount: detail.song?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _setListSongItem(
                          song: detail.song![index],
                          index: index,
                          openSongInfo: (SongsOfAlbumDetail song) => provider.showSongInfoSheet(context, song)
                      ),
                      if (index != detail.song.length - 1)
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
    required SongsOfAlbumDetail song,
    required int index,
    required Function(SongsOfAlbumDetail song) openSongInfo
  }) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: YMusicSpacing.lg,
        vertical: YMusicSpacing.sm,
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: YMusicSpacing.md
            ),
            child: Text(
                '${index + 1}',
                style: YMusicTextStyles.bodyLarge
            ),
          ),
          SizedBox(width: YMusicSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 歌曲名称
                Text(
                    song.name ?? '',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: YMusicTextStyles.bodyLarge
                ),
                // const SizedBox(height: YMusicSpacing.xxs),
                /// 歌手名称
                // Text(
                //     song.artistNames ?? '',
                //     maxLines: 1,
                //     overflow:
                //     TextOverflow.ellipsis,
                //     style: YMusicTextStyles.bodySmall
                // ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          /// 更多按钮
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