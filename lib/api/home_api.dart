import 'package:dio/dio.dart';

import '../models/daily_recommend.dart';
import '../models/new_discover.dart';
import 'constants.dart';

final Dio dio = Dio();

class HomeApi {
  /// 获取发现 Banner
  static Future<List<NewDiscoverModel>> fetchDiscoverBanner() async {
    final response = await dio.get(
      '$baseUrl/top/song?type=0',
    );
    final List list = response.data['data'];
    return list.map((e) {
      return NewDiscoverModel.fromJson(e);
    }).toList();
  }
  /// 获取日推
  static Future<List<DailyRecommend>> fetchDailyRecommend() async {
    final response = await dio.get(
      '$baseUrl/recommend/songs',
    );
    final List list = response.data['data']?['dailySongs'];
    return list.map((e) {
      return DailyRecommend.fromJson(e);
    }).toList();
  }
}