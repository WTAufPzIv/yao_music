import '../api/home_api.dart';
import '../models/new_discover.dart';

class HomeService {
  /// 获取发现 Banner
  static Future<List<NewDiscoverModel>> getDiscoverBanner() async {
    final result = await HomeApi.fetchDiscoverBanner();
    return result.take(10).toList();
  }
}