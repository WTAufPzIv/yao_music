import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/constants/load_state.dart';
import 'package:yao_music/models/search.dart';
import 'package:yao_music/pages/artist_detail/artist_detail.dart';
import 'package:yao_music/providers/user/local_tab.dart';
import 'package:yao_music/theme/app_text.dart';

import '../models/set_list_detail.dart';
import '../pages/album_detail/album_detail.dart';
import '../services/set_list_detail_service.dart';
import '../theme/app_color.dart';
import '../theme/app_space.dart';
import 'album_detail_provider.dart';
import 'artist_detail_provider.dart';

class SetListProvider extends ChangeNotifier {
  /// 页面背景色
  Color bgColor = YMusicColors.background;
  SetListDetailModel detail = SetListDetailModel(
    id: 1,
    name: '这是歌单名称',
    coverImgUrl: 'lib/assets/image/banner.jpg',
    description: '这是一大堆表述',
    updateTime: 123456789,
    songs: [
      SetListDetailSongsModel(
        id: 2,
        name: '这是歌曲名称',
        artistList: [
          ArtistOfSetListSong(
            id: 3,
            name: '这是歌手名称'
          ),
        ],
        album: AlbumOfSetListSong(
          id: 4,
          name: '这是专辑名称',
          picUrl: 'lib/assets/image/banner.jpg'
        )
      )
    ]
  );
  LoadState loadState = LoadState.loading;

  /// 提取封面主色
  Future<void> updateBgColor() async {
    if (detail.coverImgUrl != null && detail.coverImgUrl!.isNotEmpty) {
      try {
        final paletteGenerator = await PaletteGenerator.fromImageProvider(
          CachedNetworkImageProvider(
            detail.coverImgUrl ?? '',
            headers: {
              "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
            },
          ),
          maximumColorCount: 20,
        );
        final color = paletteGenerator.dominantColor?.color;
        if (color != null) {
          bgColor = Color.lerp(color, Colors.black, 0.4)!;
        }
      } catch (_) {}
    }
  }

  /// 加载数据
  Future<void> loadSetListDetailData(int id) async {
    try {
      bgColor = YMusicColors.background;
      loadState = LoadState.loading;
      notifyListeners();
      final result = await SetListDetailService.getSetListDetail(id);
      detail = result;
      loadState = LoadState.success;
      await updateBgColor();
    } catch (e) {
      loadState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> showDescriptionSheet (BuildContext context, String description) async {
    final maxHeight = MediaQuery.of(context).size.height * 0.5;
    showModalBottomSheet(
      context: context,
      backgroundColor: YMusicColors.background,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            padding: EdgeInsetsGeometry.only(bottom: 35),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E).withOpacity(0.94),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 顶部拖拽条
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 8,
                  ),
                  child: Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),

                /// 标题
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    "歌单简介",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                /// 内容
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      8,
                      24,
                      32,
                    ),
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showSongInfoSheet (BuildContext context, SetListDetailSongsModel song) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: YMusicColors.background,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 500,
            ),
            padding: EdgeInsetsGeometry.only(bottom: 35),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E).withOpacity(0.94),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 顶部拖拽条
                Padding(
                  padding: const EdgeInsets.only(
                    top: YMusicSpacing.md,
                  ),
                  child: Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: YMusicSpacing.md,
                    vertical: YMusicSpacing.md,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (song.artistList.length > 1) {
                            Navigator.pop(sheetContext);
                            _showArtistPickerSheet(context, song);
                          } else {
                            Navigator.pop(sheetContext);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: const RouteSettings(
                                  name: "/ArtistDetail",
                                ),
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => ArtistDetailProvider(),
                                  child: ArtistDetail(artistId: song.artistList[0].id),
                                ),
                              ),
                            );
                          }
                        },
                        child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: YMusicSpacing.lg,
                                horizontal: YMusicSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                      CupertinoIcons.music_mic,
                                      color: YMusicColors.primary,
                                      size: 25
                                  ),
                                  SizedBox(
                                    width: YMusicSpacing.md,
                                  ),
                                  Text(
                                      '歌手：${song.artistNames}',
                                      style: YMusicTextStyles.body,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                      const Divider(
                        height: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.white12,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: const RouteSettings(
                                name: "/AlbumDetail",
                              ),
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => AlbumDetailProvider(),
                                child: AlbumDetail(albumId: song.album.id),
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: YMusicSpacing.sm,
                              vertical: YMusicSpacing.lg,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                    CupertinoIcons.square_stack_3d_down_right,
                                    color: YMusicColors.primary,
                                    size: 25
                                ),
                                SizedBox(
                                  width: YMusicSpacing.md,
                                ),
                                Text(
                                    '专辑：${song.album.name}',
                                    style: YMusicTextStyles.body,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis
                                )
                              ],
                            ),
                          )
                        ),
                      ),
                      const Divider(
                        height: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.white12,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: YMusicSpacing.sm,
                              vertical: YMusicSpacing.lg,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                    CupertinoIcons.cloud_download,
                                    color: YMusicColors.primary,
                                    size: 25
                                ),
                                SizedBox(
                                  width: YMusicSpacing.md,
                                ),
                                Text(
                                    '下载',
                                    style: YMusicTextStyles.body
                                )
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showArtistPickerSheet(BuildContext context, SetListDetailSongsModel song) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 520),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E).withOpacity(0.96),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsetsGeometry.only(bottom: 35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: YMusicSpacing.md),
                  child: Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    YMusicSpacing.lg,
                    YMusicSpacing.lg,
                    YMusicSpacing.lg,
                    YMusicSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Text('选择歌手', style: YMusicTextStyles.title3),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: YMusicSpacing.lg),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '这首歌由多个歌手参与演唱',
                      style: YMusicTextStyles.artistName,
                    ),
                  ),
                ),
                const SizedBox(height: YMusicSpacing.md),
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      YMusicSpacing.md,
                      0,
                      YMusicSpacing.md,
                      YMusicSpacing.md,
                    ),
                    itemCount: song.artistList.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: Colors.white12,
                    ),
                    itemBuilder: (context, index) {
                      final artist = song.artistList[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: const RouteSettings(
                                name: "/ArtistDetail",
                              ),
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => ArtistDetailProvider(),
                                child: ArtistDetail(artistId: artist.id),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: YMusicSpacing.sm,
                            vertical: YMusicSpacing.lg,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  artist.name.isNotEmpty ? artist.name.characters.first : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: YMusicSpacing.md),
                              Expanded(
                                child: Text(
                                  artist.name,
                                  style: YMusicTextStyles.body,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white.withOpacity(0.35),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showAddToLocalSheet (BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: YMusicColors.background,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 500,
            ),
            padding: EdgeInsetsGeometry.only(bottom: 35),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E).withOpacity(0.94),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 顶部拖拽条
                Padding(
                  padding: const EdgeInsets.only(
                    top: YMusicSpacing.md,
                  ),
                  child: Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: YMusicSpacing.md,
                    vertical: YMusicSpacing.md,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final localTabProvider = context.read<LocalTabProvider>();
                          final randomId = DateTime.now().millisecondsSinceEpoch + Random().nextInt(99999);
                          final playlistItem = LocalSetListDetailModel(
                              id: randomId,
                              name: '[本地]${detail.name}',
                              cover: 'https://picsum.photos/seed/$randomId/800/800',
                              songs: detail.songs.map((e){
                                return LocalSetListDetailSongsModel(
                                  id: e.id.toString(),
                                  name: e.name,
                                  platform: SearchPlatform.netease,
                                  artistList: e.artistList,
                                  album: e.album,
                                );
                              }).toList()
                          );
                          localTabProvider.inertLocalPlayList(playlistItem);
                          Navigator.pop(sheetContext);
                        },
                        child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: YMusicSpacing.lg,
                                horizontal: YMusicSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                      CupertinoIcons.create_solid,
                                      color: YMusicColors.primary,
                                      size: 25
                                  ),
                                  SizedBox(
                                    width: YMusicSpacing.md,
                                  ),
                                  Text(
                                      '一键创建为本地歌单',
                                      style: YMusicTextStyles.body,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}