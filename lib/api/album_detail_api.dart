import '../models/album_detail.dart';
import 'base/dio_http.dart';
import 'constants.dart';
import 'home_api.dart';

class AlbumDetailApi {
  /// 获取专辑详情
  static Future<AlbumDetailModel> fetchAlbumDetail(int id) async {
    final results = await DioHttp.dio.get('$baseUrl/album?id=$id');
    final Map<String, dynamic> album = results.data['album'];
    album['song'] = results.data['songs'];
    album['artistList'] = results.data['album']?['artists'];
    return AlbumDetailModel.fromJson(album);
  }
}