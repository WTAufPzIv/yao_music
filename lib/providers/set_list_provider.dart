import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:yao_music/constants/load_state.dart';

import '../models/set_list_detail.dart';
import '../services/set_list_detail_service.dart';
import '../theme/app_color.dart';

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
          print(bgColor);
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
}