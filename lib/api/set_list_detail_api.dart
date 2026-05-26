import '../models/set_list_detail.dart';
import 'constants.dart';
import 'home_api.dart';

class SetListDetailApi {
  /// 获取歌单详情
  static Future<SetListDetailModel> fetchSetListDetail(int id) async {
    final results = await Future.wait([
      dio.get('$baseUrl/playlist/detail?id=$id&s=1'),
      dio.get('$baseUrl/playlist/track/all?id=$id'),
    ]);
    final response1 = results[0];
    final response2 = results[1];
    final Map<String, dynamic> detail = response1.data['playlist'];
    detail['songs'] = response2.data['songs'];
    return SetListDetailModel.fromJson(detail);
  }
}