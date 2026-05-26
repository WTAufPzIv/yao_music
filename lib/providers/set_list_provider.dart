import 'package:flutter/cupertino.dart';
import 'package:yao_music/constants/load_state.dart';

import '../models/set_list_detail.dart';
import '../services/set_list_detail_service.dart';

class SetListProvider extends ChangeNotifier {
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
          )
        ]
      )
    ]
  );
  LoadState loadState = LoadState.loading;

  /// 加载数据
  Future<void> loadSetListDetailData(int id) async {
    try {
      print(1111111);
      loadState = LoadState.loading;
      notifyListeners();
      final result = await SetListDetailService.getSetListDetail(id);
      detail = result;
      print(result);
      loadState = LoadState.success;
    } catch (e) {
      loadState = LoadState.error;
      print(e);
    }
    notifyListeners();
  }
}