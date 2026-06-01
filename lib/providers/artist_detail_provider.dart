import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/pages/album_detail/album_detail.dart';

import '../constants/load_state.dart';
import '../models/artist_detail.dart';
import '../models/base/page_base.dart';
import '../services/artist_detail_service.dart';
import '../theme/app_color.dart';
import '../theme/app_space.dart';
import '../theme/app_text.dart';
import 'album_detail_provider.dart';
import 'base/base_page_provider.dart';

class ArtistDetailProvider extends ChangeNotifier {
  /// 页面背景色
  Color bgColor = YMusicColors.background;
  ArtistDetailModel detail = ArtistDetailModel(
      id: 1,
      name: '这是专辑名称',
      cover: 'lib/assets/image/banner.jpg',
      transNames: ['这是翻译'],
      briefDesc: '这是一大堆表述',
      introduction: [
        IntroductionItem(
          ti: '演绎经历',
          text: '这是演绎经历介绍'
        )
      ],
      song: [
        SongsOfArtistDetail(
            id: 2,
            name: '这是歌曲名称',
            artistList: [
              ArtistOfArtistDetail(
                  id: 3,
                  name: '这是歌手名称'
              ),
            ],
            album: AlbumOfArtistDetail(
                id: 4,
                name: '这是专辑名称',
                picUrl: 'lib/assets/image/banner.jpg'
            )
        )
      ],
      album: [
        AlbumOfArtistDetail(
          id: 3,
          name: '这是歌手名称',
          picUrl: 'lib/assets/image/banner.jpg',
        ),
      ]
  );
  LoadState loadState = LoadState.loading;

  /// 加载数据
  Future<void> loadArtistDetailData(int id) async {
    try {
      bgColor = YMusicColors.background;
      loadState = LoadState.loading;
      notifyListeners();
      final result = await ArtistDetailService.getArtistDetail(id);
      detail = result;
      loadState = LoadState.success;
    } catch (e) {
      loadState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> showSongInfoSheet (BuildContext context, SongsOfArtistDetail song) async {
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

  Future<void> showDescriptionSheet (BuildContext context, ArtistDetailModel artist) async {
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
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
                    "歌手简介",
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
                          artist.briefDesc,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.7,
                          ),
                        ),
                        artist.introduction != null && !artist.introduction.isEmpty ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            artist.introduction.length,
                                (index) {
                              final item = artist.introduction[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: YMusicSpacing.lg,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.ti,
                                      style: YMusicTextStyles.title3,
                                    ),
                                    const SizedBox(height: YMusicSpacing.sm),
                                    Text(
                                      item.text,
                                      style: YMusicTextStyles.body,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ) : SizedBox(
                          height: YMusicSpacing.md,
                        )
                      ],
                    )
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ArtistAllSongProvider extends BasePageProvider<SongsOfArtistDetail> {
  final int artistId;
  ArtistAllSongOrderType order = ArtistAllSongOrderType.hot;

  ArtistAllSongProvider(this.artistId);

  void changeOrder(ArtistAllSongOrderType newOrder) {
    notifyListeners();
    order = newOrder;
    notifyListeners();
    refresh();
  }

  @override
  Future<PageData<SongsOfArtistDetail>> fetchData({
    required int offset,
    required int limit,
  }) async {
    final result = await ArtistDetailService.getArtistAllSongPage(artistId, ArtistAllSongDTO(order, offset: offset, limit: limit));
    return PageData(list: result.song, more: result.more);
  }
}

class ArtistAllAlbumProvider extends BasePageProvider<AlbumOfArtistDetail> {
  final int artistId;
  ArtistAllSongOrderType order = ArtistAllSongOrderType.hot;

  ArtistAllAlbumProvider(this.artistId);

  void changeOrder(ArtistAllSongOrderType newOrder) {
    notifyListeners();
    order = newOrder;
    notifyListeners();
    refresh();
  }

  @override
  Future<PageData<AlbumOfArtistDetail>> fetchData({
    required int offset,
    required int limit,
  }) async {
    final result = await ArtistDetailService.getArtistAllAlbumPage(artistId, ArtistAllAlbumDTO(order, offset: offset, limit: limit));
    return PageData(list: result.album, more: result.more);
  }
}