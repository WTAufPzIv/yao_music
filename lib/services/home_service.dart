import '../api/home_api.dart';
import '../models/daily_recommend.dart';
import '../models/hot_top.dart';
import '../models/new_album_release.dart';
import '../models/new_discover.dart';
import '../models/personalized_set_list.dart';
import '../models/rank_list.dart';

class HomeService {
  /// 获取发现 Banner
  static Future<List<NewDiscoverModel>> getDiscoverBanner() async {
    final result = await HomeApi.fetchDiscoverBanner();
    return result.take(20).toList();
  }
  /// 获取日推
  static Future<List<DailyRecommendModel>> getDailyRecommend() async {
    final result = await HomeApi.fetchDailyRecommend();
    return result.take(20).toList();
  }
  /// 获取推荐歌单
  static Future<List<PersonalizedSetListModel>> getPersonalizedSetList() async  {
    final result = await HomeApi.fetchPersonalizedSetList();
    return result.take(20).toList();
  }
  /// 获取推荐歌单 - 100
  static Future<List<PersonalizedSetListModel>> getPersonalizedSetListFull() async  {
    final result = await HomeApi.fetchPersonalizedSetListFull();
    return result.take(100).toList();
  }
  /// 获取新碟上架
  static Future<List<NewAlbumReleaseModel>> getNewAlbumRelease() async  {
    final result = await HomeApi.fetchNewAlbumRelease();
    return result.take(10).toList();
  }
  /// 获取新碟上架
  static Future<List<NewAlbumReleaseModel>> getNewAlbumReleaseFull() async  {
    final result = await HomeApi.fetchNewAlbumRelease();
    return result.toList();
  }
  /// 获取热歌榜前20
  static Future<List<HotTopModel>> getHotTop() async  {
    final result = await HomeApi.fetchHotTop();
    return result.take(20).toList();
  }
  /// 获取榜单列表
  static Future<List<RankListModel>> getRankList() async  {
    final result = await HomeApi.fetchRankList();
    return result.take(4).toList();
  }
}