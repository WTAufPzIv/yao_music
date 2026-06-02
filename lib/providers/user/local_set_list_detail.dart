import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/set_list_detail.dart';
import '../../pages/album_detail/album_detail.dart';
import '../../pages/artist_detail/artist_detail.dart';
import '../../theme/app_color.dart';
import '../../theme/app_space.dart';
import '../../theme/app_text.dart';
import '../album_detail_provider.dart';
import '../artist_detail_provider.dart';

class LocalSetListDetailProvider extends ChangeNotifier {

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
}