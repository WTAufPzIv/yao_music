import 'package:dio/dio.dart';

import '../models/new_discover.dart';

final Dio dio = Dio();

class HomeApi {
  /// 获取发现 Banner
  static Future<List<NewDiscoverModel>> fetchDiscoverBanner() async {
    final response = await dio.get(
      'https://api-enhanced-psi-navy.vercel.app/top/song?type=0',
    );
    final List list = response.data['data'];
    return list.map((e) {
      return NewDiscoverModel.fromJson(e);
    }).toList();
  }
}