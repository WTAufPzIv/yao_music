import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/set_list_detail.dart';
import '../../pages/user/storage/user_local_Storage.dart';
import '../../theme/app_color.dart';
import '../../theme/app_space.dart';
import '../../theme/app_text.dart';

class LocalTabProvider extends ChangeNotifier {
  bool localLoading = true;
  List<LocalSetListDetailModel> localPlaylists = [];

  Future<void> loadLocalPlaylists() async {
    final list = await LocalPlaylistStorage.load();
    localPlaylists = list;
    localLoading = false;
    notifyListeners();
  }

  Future<void> _saveLocalPlaylists() async {
    await LocalPlaylistStorage.save(localPlaylists);
  }

  Future<void> inertLocalPlayList(LocalSetListDetailModel item) async {
    localPlaylists.insert(0, item);
    notifyListeners();
    await _saveLocalPlaylists();
  }

  Future<void> removeFormLocalPlayList(int index) async {
    if (index < 0 || index >= localPlaylists.length) {
      return;
    }
    localPlaylists.removeAt(index);
    notifyListeners();
    await _saveLocalPlaylists();
  }

  Future<void> openDeleteSheet (int index, BuildContext context) async {
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
                          Navigator.pop(sheetContext);
                          return removeFormLocalPlayList(index);
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
                                      CupertinoIcons.delete,
                                      color: YMusicColors.primary,
                                      size: 25
                                  ),
                                  SizedBox(
                                    width: YMusicSpacing.md,
                                  ),
                                  Text(
                                      '删除歌单',
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

  Future<void> addSongToLocalPlayList (LocalSetListDetailSongsModel item, BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: YMusicColors.background,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 500,
              ),
              padding: const EdgeInsets.only(
                bottom: 35,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E).withOpacity(0.94),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: YMusicSpacing.sm
                    ),
                  ),
                  Text('添加到歌单'),
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

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: YMusicSpacing.md,
                        vertical: YMusicSpacing.md,
                      ),
                      child: ListView.builder(
                        itemCount: localPlaylists.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              localPlaylists[index].songs.insert(0, item);
                              _saveLocalPlaylists();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: YMusicSpacing.lg,
                                horizontal: YMusicSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      localPlaylists[index].name,
                                      style: YMusicTextStyles.body,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }
}