import '../api/album_detail_api.dart';
import '../models/album_detail.dart';

class AlbumDetailService {
  /// 获取专辑详情
  static Future<AlbumDetailModel> getAlbumDetail(int id) async {
    final result = await AlbumDetailApi.fetchAlbumDetail(id);
    return result;
  }
}