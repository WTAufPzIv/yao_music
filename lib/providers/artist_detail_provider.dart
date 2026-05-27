import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../constants/load_state.dart';
import '../models/artist_detail.dart';
import '../services/artist_detail_service.dart';
import '../theme/app_color.dart';

class ArtistDetailProvider extends ChangeNotifier {
  /// 页面背景色
  Color bgColor = YMusicColors.background;
  ArtistDetailModel detail = ArtistDetailModel(
      id: 1,
      name: '这是专辑名称',
      cover: 'lib/assets/image/banner.jpg',
      transNames: ['这是翻译'],
      briefDesc: '这是一大堆表述',
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
      print(e);
      loadState = LoadState.error;
    }
    notifyListeners();
  }
}