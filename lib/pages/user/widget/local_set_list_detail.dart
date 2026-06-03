import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/theme/app_color.dart';
import 'package:yao_music/theme/app_text.dart';

import '../../../components/music_cover.dart';
import '../../../models/search.dart';
import '../../../models/set_list_detail.dart';
import '../../../models/song_detail.dart';
import '../../../providers/user/local_set_list_detail.dart';
import '../../../providers/song_detail_provider.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';

class LocalSetListDetail extends StatefulWidget {
  final LocalSetListDetailModel detail;
  const LocalSetListDetail({ super.key, required this.detail });

  @override
  State<LocalSetListDetail> createState() => _SetListDetailState();
}

class _SetListDetailState extends State<LocalSetListDetail> {
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
    /// 监听滚动
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocalSetListDetailProvider>();
    final playerProvider = context.read<SongDetailProvider>();
    final Color bgColor = YMusicColors.background;
    final detail = widget.detail;
    return Scaffold(
        backgroundColor: bgColor,
        body: AnimatedContainer(
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
                          detail.cover.startsWith('http') ? CachedNetworkImage(
                              imageUrl: detail.cover,
                              httpHeaders: {'user-agent': 'windows'},
                              width: 180,
                              height: 180,
                              fit: BoxFit.cover
                          ) : Image.asset(
                            "/1.png",
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                width: 180,
                                height: 180,
                                color: Colors.white10,
                                child: const Icon(Icons.music_note, color: Colors.white54, size: 46),
                              );
                            },
                          ),
                          /// 渐变遮罩
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  bgColor.withOpacity(0.01),
                                  bgColor.withOpacity(0.15),
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
                                  /// 标题
                                  Text(
                                    detail.name ?? '',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: YMusicTextStyles.title3,
                                  ),
                                  const SizedBox(height: YMusicSpacing.sm),
                                  GestureDetector(
                                    onTap: () {
                                      playerProvider.setPlayListAndPlay(
                                          detail.songs.map(
                                                  (e) =>
                                                  SingMiniInfo(
                                                      id: e.id.toString(),
                                                      coverUrl: e.album.picUrl,
                                                      platform: e.platform,
                                                      name: e.name,
                                                      artistName: e.artistNames,
                                                      albumName: e.album.name
                                                  )).toList(),
                                          0
                                      );
                                    },
                                    child:  SizedBox(
                                      width: 200,
                                      child: _actionButton(
                                        icon:
                                        Icons.play_arrow_rounded,
                                        text: '播放',
                                      ),
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
                      GestureDetector(
                        onTap: () {
                          playerProvider.setPlayListAndPlay(
                              detail.songs.map(
                                      (e) =>
                                      SingMiniInfo(
                                          id: e.id.toString(),
                                          picId: e.picId,
                                          coverUrl: e.album.picUrl,
                                          platform: e.platform,
                                          name: e.name,
                                          artistName: e.artistNames,
                                          albumName: e.album.name
                                      )).toList(),
                              index
                          );
                        },
                        child: _setListSongItem(
                            song: LocalSetListDetailSongsModel(
                              id: detail.songs![index].id,
                              name: detail.songs![index].name,
                              platform: detail.songs![index].platform,
                              artistList: detail.songs![index].artistList,
                              album: detail.songs![index].album,
                              picId: detail.songs![index].picId
                            ),
                            index: index,
                            openSongInfo: (LocalSetListDetailSongsModel song) => provider.showSongInfoSheet(context, song)
                        ),
                      ),
                      if (index != detail.songs.length - 1)
                        const Divider(
                          height: 1,
                          indent: YMusicSpacing.lg,
                          endIndent: 16,
                          color: Colors.white12,
                        ) else
                        const SizedBox(
                          height: 80,
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
    required LocalSetListDetailSongsModel song,
    required int index,
    required Function(LocalSetListDetailSongsModel song) openSongInfo
  }) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: YMusicSpacing.lg,
        vertical: YMusicSpacing.sm,
      ),
      child: Row(
        children: [
          song.album.picUrl != null && song.album.picUrl.isNotEmpty ? MusicCover(
            imageUrl: '${song.album.picUrl}?param=100y100',
            width: 52,
            height: 52,
            radius: YMusicRadius.sm,
          ) : Image.asset(
            "/1.png",
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                width: 52,
                height: 52,
                color: Colors.white10,
                child: const Icon(Icons.music_note, color: Colors.white54, size: 46),
              );
            },
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
                Row(
                  children: [
                    Text(
                        song.artistNames ?? '',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: YMusicTextStyles.bodySmall
                    ),
                    Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: YMusicSpacing.md)),
                    Text(
                        song.platform.name ?? '',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: YMusicTextStyles.bodySmall
                    ),
                  ],
                )
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