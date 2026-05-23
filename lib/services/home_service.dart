import '../api/home_api.dart';
import '../models/daily_recommend.dart';
import '../models/new_discover.dart';

class HomeService {
  /// 获取发现 Banner
  static Future<List<NewDiscoverModel>> getDiscoverBanner() async {
    final result = await HomeApi.fetchDiscoverBanner();
    return result.take(20).toList();
  }
  /// 获取日推
  static Future<List<DailyRecommend>> getDailyRecommend() async {
    final result = await HomeApi.fetchDailyRecommend();
    return result.take(20).toList();
  }
}