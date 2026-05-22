import 'package:flutter/material.dart';

import '../constants/load_state.dart';
import '../models/new_discover.dart';
import '../services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  /// Banner 数据
  List<NewDiscoverModel> banners = [];
  /// 页面状态
  LoadState loadState = LoadState.loading;
  /// 加载首页数据
  Future<void> loadData() async {
    banners = [NewDiscoverModel(
        id: 1999,
        name: '1111',
        album: '1111111',
        artists: [ArtistModel(name: '111111')],
        image: 'lib/assets/image/banner.jpg'
    )];
    try {
      loadState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getDiscoverBanner();
      banners = result;
      if (banners.isEmpty) {
        loadState = LoadState.empty;
      } else {
        loadState = LoadState.success;
      }
    } catch (e) {
      loadState = LoadState.error;
    }
    notifyListeners();
  }
}