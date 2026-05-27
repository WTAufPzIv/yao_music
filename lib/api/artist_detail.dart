import '../models/album_detail.dart';
import '../models/artist_detail.dart';
import 'constants.dart';
import 'home_api.dart';

class ArtistDetailApi {
  /// 获取歌手详情
  static Future<ArtistDetailModel> fetchArtistDetail(int id) async {
    final results = await Future.wait([
      dio.get('$baseUrl/artist/detail?id=$id'),
      dio.get('$baseUrl/artist/top/song?id=$id'),
      dio.get('$baseUrl/artist/album?id=$id&limit=20'),
    ]);
    final response1 = results[0];
    final response2 = results[1];
    final response3 = results[2];
    final Map<String, dynamic> detail = response1.data['data']?['artist'];
    detail['song'] = response2.data['songs'];
    detail['album'] = response3.data['hotAlbums'];
    print(detail);
    return ArtistDetailModel.fromJson(detail);
  }
}