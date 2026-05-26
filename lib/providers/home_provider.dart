import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yao_music/models/hot_top.dart';
import 'package:yao_music/models/personalized_set_list.dart';
import 'package:yao_music/models/rank_list.dart';

import '../constants/load_state.dart';
import '../models/daily_recommend.dart';
import '../models/new_album_release.dart';
import '../models/new_discover.dart';
import '../services/home_service.dart';
import '../utils/index.dart';

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
  /// 推荐歌单数据 -100
  List<PersonalizedSetListModel> personalizedFull = [];
  /// 推荐歌单加载状态 - 100
  LoadState loadPersonalizedStateFull = LoadState.loading;
  /// 新碟上架数据
  List<NewAlbumReleaseModel> newAlbum = [];
  /// 新碟上架加载状态
  LoadState loadNewAlbumReleaseState = LoadState.loading;
  /// 新碟上架数据 - full
  List<NewAlbumReleaseModel> newAlbumFull = [];
  /// 新碟上架加载状态 - full
  LoadState loadNewAlbumReleaseStateFull = LoadState.loading;
  /// 热歌榜数据
  List<HotTopModel> hot = [];
  /// 热歌榜加载状态
  LoadState loadHotTopState = LoadState.loading;
  /// 榜单数据
  List<RankListModel> rank = [];
  /// 榜单数据加载状态
  LoadState loadRankListState = LoadState.loading;

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
      nextFrame(() {
        loadDailyState = LoadState.success;
      });
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
  /// 加载推荐歌单 - 100
  Future<void> loadPersonalizedSetListDataFull() async {
    List<PersonalizedSetListModel> place = List.generate(
      8,
          (_) => PersonalizedSetListModel(
          id: random.nextInt(100),
          name: '这是歌单名称',
          picUrl: 'lib/assets/image/banner.jpg'
      ),
    );
    personalizedFull = place;
    try {
      loadPersonalizedStateFull = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getPersonalizedSetListFull();
      personalizedFull = result;
      loadPersonalizedStateFull = LoadState.success;
    } catch (e) {
      loadPersonalizedStateFull = LoadState.error;
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
  /// 加载新碟上架 - full
  Future<void> loadNewAlbumReleaseFull() async {
    List<NewAlbumReleaseModel> place = List.generate(
      6,
          (_) => NewAlbumReleaseModel(
          id: random.nextInt(100),
          name: '这是专辑名称',
          picUrl: 'lib/assets/image/banner.jpg',
          artistList: [ ArtistOfNewAlbumReleaseModel(id: random.nextInt(100), name: '歌手名') ]
      ),
    );
    newAlbumFull = place;
    try {
      loadNewAlbumReleaseStateFull = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getNewAlbumRelease();
      newAlbumFull = result;
      loadNewAlbumReleaseStateFull = LoadState.success;
    } catch (e) {
      loadNewAlbumReleaseStateFull = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载热歌榜
  Future<void> loadHotTop() async {
    List<HotTopModel> place = List.generate(
      10,
          (_) => HotTopModel(
          id: random.nextInt(100),
          name: '这是专辑名称',
          album: AlbumOfHotTop( id: random.nextInt(100), name: '这是专辑名称', picUrl: 'lib/assets/image/banner.jpg' ),
          artistList: [ ArtistOfHotTop(id: random.nextInt(100), name: '歌手名') ]
      ),
    );
    hot = place;
    try {
      loadHotTopState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getHotTop();
      hot = result;
      loadHotTopState = LoadState.success;
    } catch (e) {
      loadHotTopState = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载榜单
  Future<void> loadRankList() async {
    List<RankListModel> place = List.generate(
      10,
          (_) => RankListModel(
          id: random.nextInt(100),
          name: '排行榜',
          coverImgUrl: 'lib/assets/image/banner.jpg',
      ),
    );
    rank = place;
    try {
      loadRankListState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getRankList();
      rank = result;
      loadRankListState = LoadState.success;
    } catch (e) {
      loadRankListState = LoadState.error;
    }
    notifyListeners();
  }
}