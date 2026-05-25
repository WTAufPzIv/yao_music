import '../api/home_api.dart';
import '../models/daily_recommend.dart';
import '../models/new_album_release.dart';
import '../models/new_discover.dart';
import '../models/personalized_set_list.dart';

class HomeService {
  /// 获取发现 Banner
  static Future<List<NewDiscoverModel>> getDiscoverBanner() async {
    final result = await HomeApi.fetchDiscoverBanner();
    return result.take(20).toList();
  }
  /// 获取日推
  static Future<List<DailyRecommendModel>> getDailyRecommend() async {
    final result = await HomeApi.fetchDailyRecommend();
    return result.take(12).toList();
  }
  /// 获取推荐歌单
  static Future<List<PersonalizedSetListModel>> getPersonalizedSetList() async  {
    final result = await HomeApi.fetchPersonalizedSetList();
    return result.take(20).toList();
  }
  /// 获取新碟上架
  static Future<List<NewAlbumReleaseModel>> getNewAlbumRelease() async  {
    final result = await HomeApi.fetchNewAlbumRelease();
    return result.take(10).toList();
  }
}