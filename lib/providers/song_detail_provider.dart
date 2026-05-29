import 'package:flutter/cupertino.dart';
import 'package:yao_music/constants/load_state.dart';
import 'package:yao_music/models/search.dart';

import '../models/song_detail.dart';
import '../services/song_detail_service.dart';

class SongDetailProvider extends ChangeNotifier {
  SingMiniInfo curInfo = SingMiniInfo(id: 0, platform: SearchPlatform.netease, name: '', artistName: '', albumName: '', coverUrl: '');
  String curUrl = '';
  LoadState loadState = LoadState.loading;
  List<SingMiniInfo> playListIds = [];
  /// 当前是否显示播放器按钮
  bool visible = true;
  /// 是否播放中
  bool playing = false;

  void togglePlay() {
    playing = !playing;
    notifyListeners();
  }

  Future<void> fetchUrlAndPlay(SingMiniInfo mini) async {
    if (curInfo.id > 0 && curInfo.id == mini.id) return;
    try {
      notifyListeners();
      curInfo = mini;
      loadState = LoadState.loading;
      final result = await SongDetailService.getSongDetail(SongDTO(
          id: mini.id,
          platform: mini.platform
      ));
      curUrl = result;
      notifyListeners();
      return;
    } catch (e) {
      loadState = LoadState.error;
      notifyListeners();
      rethrow;
    }
  }
}