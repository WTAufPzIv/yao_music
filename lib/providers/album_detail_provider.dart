import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../constants/load_state.dart';
import '../models/album_detail.dart';
import '../services/album_detail_service.dart';
import '../theme/app_color.dart';
import '../theme/app_space.dart';
import '../theme/app_text.dart';
import '../utils/index.dart';

class AlbumDetailProvider extends ChangeNotifier {
  /// 页面背景色
  Color bgColor = YMusicColors.background;
  AlbumDetailModel detail = AlbumDetailModel(
      id: 1,
      name: '这是专辑名称',
      picUrl: 'lib/assets/image/banner.jpg',
      description: '这是一大堆表述',
      publishTime: 123456789,
      company: '这是出品公司',
      song: [
        SongsOfAlbumDetail(
            id: 2,
            name: '这是歌曲名称',
            artistList: [
              ArtistOfAlbumDetail(
                  id: 3,
                  name: '这是歌手名称'
              ),
            ],
            album: AlbumOfAlbumDetail(
                id: 4,
                name: '这是专辑名称',
                picUrl: 'lib/assets/image/banner.jpg'
            )
        )
      ],
      artistList: [
        ArtistOfAlbumDetail(
            id: 3,
            name: '这是歌手名称'
        ),
      ]
  );
  LoadState loadState = LoadState.loading;

  /// 提取封面主色
  Future<void> updateBgColor() async {
    if (detail.picUrl != null && detail.picUrl!.isNotEmpty) {
      try {
        final paletteGenerator = await PaletteGenerator.fromImageProvider(
          CachedNetworkImageProvider(
            detail.picUrl ?? '',
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
  Future<void> loadAlbumDetailData(int id) async {
    try {
      bgColor = YMusicColors.background;
      loadState = LoadState.loading;
      notifyListeners();
      final result = await AlbumDetailService.getAlbumDetail(id);
      detail = result;
      loadState = LoadState.success;
      await updateBgColor();
    } catch (e) {
      loadState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> showDescriptionSheet (BuildContext context, AlbumDetailModel description) async {
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
                    "专辑简介",
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.7,
                          ),
                        ),
                        SizedBox(
                          height: YMusicSpacing.sm,
                        ),
                        Text(
                          "发行日期：${DateUtil.formatDate(detail.publishTime)}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.7,
                          ),
                        ),
                        SizedBox(
                          height: YMusicSpacing.sm,
                        ),
                        Text(
                          "发行公司：${detail.company}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.7,
                          ),
                        ),
                      ],
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

  Future<void> showSongInfoSheet (BuildContext context, SongsOfAlbumDetail song) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: YMusicColors.background,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 500,
            ),
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
                      SizedBox(
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
}