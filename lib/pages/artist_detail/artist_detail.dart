import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/models/artist_detail.dart';
import 'package:yao_music/providers/artist_detail_provider.dart';

import '../../components/music_cover.dart';
import '../../constants/load_state.dart';
import '../../models/search.dart';
import '../../models/song_detail.dart';
import '../../providers/album_detail_provider.dart';
import '../../providers/song_detail_provider.dart';
import '../../theme/app_color.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_space.dart';
import '../../theme/app_text.dart';
import '../album_detail/album_detail.dart';
import 'artist_album_all.dart';
import 'artist_song_all.dart';

class ArtistDetail extends StatefulWidget {
  final int artistId;
  const ArtistDetail({ super.key, required this.artistId });

  @override
  State<ArtistDetail> createState() => _ArtistDetailState();
}

class _ArtistDetailState extends State<ArtistDetail> {
  final ScrollController _scrollController = ScrollController();
  /// 滚动距离
  double scrollOffset = 0;
  /// 顶部标题动画进度
  double get collapseProgress {
    if (scrollOffset <= 300) return 0;
    final progress = ((scrollOffset - 300) / 60).clamp(0.0, 1.0);
    return progress;
  }
  final PageController controller = PageController(
    viewportFraction: 0.9,
  );
  final PageController controllerAlbum = PageController(
    viewportFraction: 0.42,
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<ArtistDetailProvider>().loadArtistDetailData(widget.artistId);
    });
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
    final provider = context.watch<ArtistDetailProvider>();
    final playerProvider = context.read<SongDetailProvider>();
    bool loading = provider.loadState == LoadState.loading;
    final ArtistDetailModel detail = provider.detail;
    // 每页5个
    const int pageSize = 5;
    return Scaffold(
      backgroundColor: YMusicColors.background,
      body: loading ? const Center(
        child: CupertinoActivityIndicator(),
      ) : AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: YMusicColors.background,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              expandedHeight: 350,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      /// 背景封面
                      CachedNetworkImage(
                        imageUrl: '${detail.cover}?param=800y800',
                        width: 350,
                        height: 350,
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
                              YMusicColors.background.withOpacity(0.01),
                              YMusicColors.background.withOpacity(0.10),
                              YMusicColors.background.withOpacity(0.95),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          left: 20,
                          right: 20,
                          bottom: 0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 歌手名字
                              Text(
                                detail.name ?? '',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: YMusicTextStyles.largeTitle,
                              ),
                            ],
                          )
                      ),
                      /// 顶部标题栏（滚动后浮现）
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: YMusicColors.background.withOpacity(collapseProgress),
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
                                        color: Colors.white,
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
                                    IconButton(onPressed: () {
                                      provider.showDescriptionSheet(context, detail);
                                    }, icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ))
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
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: YMusicSpacing.lg),
                  /// 热门歌曲
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
                              name: "/ArtistSongAll",
                            ),
                            builder: (_) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (_) => ArtistDetailProvider(),
                                ),
                                ChangeNotifierProvider(
                                  create: (_) => ArtistAllSongProvider(detail.id)..init(),
                                ),
                              ],
                              child: ArtistSongAll(
                                artistId: detail.id,
                                artistName: detail.name,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '热门歌曲',
                            style: YMusicTextStyles.title3,
                          ),
                          SizedBox(width: YMusicSpacing.xxs),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white.withOpacity(0.6),
                            size: 25,
                          ),
                        ],
                      )
                    )
                  ),
                  SizedBox(height: YMusicSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: YMusicSpacing.lg,
                    ),
                    child: SizedBox(
                      height: 324,
                      child: PageView.builder(
                        controller: controller,
                        padEnds: false,
                        itemCount: 10,
                        itemBuilder: (context, pageIndex) {
                          final start = pageIndex * pageSize;
                          final end = (start + pageSize).clamp(0, detail.song.length);
                          final pageSongs = detail.song.sublist(start, end);
                          return Padding(
                            padding: const EdgeInsets.only(right: YMusicSpacing.sm),
                            child: Container(
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(YMusicRadius.lg),
                              ),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: pageSongs.length,
                                separatorBuilder: (_, __) => Divider(
                                  color: Colors.white.withOpacity(0.10),
                                  height: YMusicSpacing.lg,
                                ),
                                itemBuilder: (context, index) {
                                  final song = pageSongs[index];
                                  return GestureDetector(
                                    onTap: () {
                                      playerProvider.setPlayListAndPlay(
                                          detail.song.map(
                                                  (e) =>
                                                  SingMiniInfo(
                                                      id: e.id.toString(),
                                                      coverUrl: e.album.picUrl,
                                                      platform: SearchPlatform.netease,
                                                      name: e.name,
                                                      artistName: e.artistNames,
                                                      albumName: e.album.name
                                                  )).toList(),
                                          index
                                      );
                                    },
                                    child: SizedBox(
                                      child: _MusicItem(
                                          song: song,
                                          loading: loading,
                                          openSongInfo: (SongsOfArtistDetail song) => provider.showSongInfoSheet(context, song)
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: YMusicSpacing.xxxl),
                  /// 热门专辑
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
                              name: "/ArtistAlbumAll",
                            ),
                            builder: (_) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (_) => ArtistDetailProvider(),
                                ),
                                ChangeNotifierProvider(
                                  create: (_) => ArtistAllAlbumProvider(detail.id)..init(),
                                ),
                              ],
                              child: ArtistAlbumAll(
                                artistId: detail.id,
                                artistName: detail.name,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '热门专辑',
                            style: YMusicTextStyles.title3,
                          ),
                          SizedBox(width: YMusicSpacing.xxs),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white.withOpacity(0.6),
                            size: 25,
                          ),
                        ],
                      )
                    )
                  ),
                  SizedBox(height: YMusicSpacing.md),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: YMusicSpacing.lg,
                    ),
                    child: SizedBox(
                      height: 202,
                      child: PageView.builder(
                        controller: controllerAlbum,
                        padEnds: false,
                        itemCount: detail.album.length,
                        itemBuilder: (context, index) {
                          return  _NewAlbumReleaseCard(
                            album: detail.album[index],
                            loading: loading,
                          );
                        },
                      ),
                    )
                  ),
                  const SizedBox(
                    height: 70,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MusicItem extends StatelessWidget {
  final SongsOfArtistDetail song;
  final bool loading;
  final Function(SongsOfArtistDetail song) openSongInfo;
  const _MusicItem({
    required this.song,
    required this.loading,
    required this.openSongInfo
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          // 左侧封面
          song.album.picUrl!.startsWith('http') ? MusicCover(
            imageUrl: '${song.album.picUrl}?param=100y100',
            width: 52,
            height: 52,
            radius: YMusicRadius.sm,
          ): Image.asset(
            song.album.picUrl,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),

          const SizedBox(width: YMusicSpacing.md),

          // 中间文字
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    song.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: YMusicTextStyles.songTitle
                ),
                const SizedBox(height: YMusicSpacing.xs),
                Text(
                    song.artistNames,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: YMusicTextStyles.artistName
                ),
              ],
            ),
          ),
          const SizedBox(width: YMusicSpacing.md),
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

class _NewAlbumReleaseCard extends StatelessWidget {
  final AlbumOfArtistDetail album;
  final bool loading;
  const _NewAlbumReleaseCard({
    required this.album,
    required this.loading,
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
                  settings: const RouteSettings(
                    name: "/AlbumDetail",
                  ),
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => AlbumDetailProvider(),
                    child: AlbumDetail(albumId: album.id),
                  ),
                ),
              );
            },
            child: album.picUrl!.startsWith('http') ? MusicCover(
              imageUrl: '${album.picUrl}?param=300y300',
              width: 150,
              height: 150,
              radius: YMusicRadius.md,
            ): Image.asset(
              album.picUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: YMusicSpacing.xs),
          /// 标题
          Padding(
            padding: EdgeInsets.only(
              left: YMusicSpacing.xs,
              right: YMusicSpacing.xs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: YMusicTextStyles.artistName
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}