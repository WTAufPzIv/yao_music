import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yao_music/models/personalized_set_list.dart';

import '../constants/load_state.dart';
import '../models/daily_recommend.dart';
import '../models/new_album_release.dart';
import '../models/new_discover.dart';
import '../services/home_service.dart';

final random = Random();

class HomeProvider extends ChangeNotifier {
  /// Banner 数据
  List<NewDiscoverModel> banners = [];
  /// Banner状态
  LoadState loadBannerState = LoadState.loading;
  /// 日推数据
  List<DailyRecommendModel> daily = [];
  /// 日推加载状态
  LoadState loadDailyState = LoadState.loading;
  /// 推荐歌单数据
  List<PersonalizedSetListModel> personalized = [];
  /// 推荐歌单加载状态
  LoadState loadPersonalizedState = LoadState.loading;
  /// 新碟上架数据
  List<NewAlbumReleaseModel> newAlbum = [];
  /// 新碟上架加载状态
  LoadState loadNewAlbumReleaseState = LoadState.loading;

  /// 加载banner数据
  Future<void> loadBannerData() async {
    banners = [NewDiscoverModel(
        id: 1999,
        name: '这是一条长的缺省文字',
        album: '这是一张专辑',
        artists: [ArtistModel(name: 'AURORA')],
        image: 'lib/assets/image/banner.jpg'
    )];
    try {
      loadBannerState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getDiscoverBanner();
      banners = result;
      if (banners.isEmpty) {
        loadBannerState = LoadState.empty;
      } else {
        loadBannerState = LoadState.success;
      }
    } catch (e) {
      loadBannerState = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载日推数据
  Future<void> loadDailyData() async {
    List<DailyRecommendModel> place = List.generate(
      4,
      (_) => DailyRecommendModel(
          id: random.nextInt(100),
          name: '这是歌曲名称一首歌',
          album: AlbumOfDailyRecommend( id: random.nextInt(100), name: '这是专辑名称', picUrl: 'lib/assets/image/banner.jpg' ),
          artistList: [ ArtistOfDailyRecommend( id: random.nextInt(100), name: '这是歌手名称' ) ]
        ),
    );
    daily = place;
    try {
      loadDailyState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getDailyRecommend();
      daily = result;
      loadDailyState = LoadState.success;
    } catch (e) {
      loadDailyState = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载推荐歌单
  Future<void> loadPersonalizedSetListData() async {
    List<PersonalizedSetListModel> place = List.generate(
      6,
          (_) => PersonalizedSetListModel(
          id: random.nextInt(100),
          name: '这是歌单名称',
          picUrl: 'lib/assets/image/banner.jpg'
      ),
    );
    personalized = place;
    try {
      loadPersonalizedState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getPersonalizedSetList();
      personalized = result;
      loadPersonalizedState = LoadState.success;
    } catch (e) {
      loadPersonalizedState = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载新碟上架
  Future<void> loadNewAlbumRelease() async {
    List<NewAlbumReleaseModel> place = List.generate(
      6,
          (_) => NewAlbumReleaseModel(
          id: random.nextInt(100),
          name: '这是专辑名称',
          picUrl: 'lib/assets/image/banner.jpg',
          artistList: [ ArtistOfNewAlbumReleaseModel(id: random.nextInt(100), name: '歌手名') ]
      ),
    );
    newAlbum = place;
    try {
      loadNewAlbumReleaseState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getNewAlbumRelease();
      newAlbum = result;
      loadNewAlbumReleaseState = LoadState.success;
    } catch (e) {
      loadNewAlbumReleaseState = LoadState.error;
    }
    notifyListeners();
  }
}