import '../models/mv_all.dart';
import 'base/dio_http.dart';
import 'constants.dart';

class MvAllApi {
  /// 获取所有mv分页
  static Future<MvAllModel> fetchAllMv(MvAllDTO params) async {
    final results = await Future.wait([
      DioHttp.dio.get('$baseUrl/mv/all?area=全部&order=${params.order.name}&limit=${params.limit}&offset=${params.offset}'),
    ]);
    final response = results[0];
    return MvAllModel.fromJson(response.data);
  }
  /// 获取mv播放链接
  static Future<String> fetchMvUrl(int id) async {
    final results = await Future.wait([
      DioHttp.dio.get('$baseUrl/mv/url?id=$id&randomCNIP=true'),
    ]);
    final response = results[0];
    return response.data['data']['url'] ?? '';
  }
}