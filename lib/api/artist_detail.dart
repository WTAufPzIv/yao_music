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
      dio.get('$baseUrl/artist/desc?id=$id'),
    ]);
    final response1 = results[0];
    final response2 = results[1];
    final response3 = results[2];
    final response4 = results[3];
    final Map<String, dynamic> detail = response1.data['data']?['artist'];
    detail['song'] = response2.data['songs'];
    detail['album'] = response3.data['hotAlbums'];
    detail['briefDesc'] = response4.data['briefDesc'];
    detail['introduction'] = response4.data['introduction'];
    return ArtistDetailModel.fromJson(detail);
  }

  // 获取歌曲分页
  static Future<ArtistAllSongModel> fetchArtistAllSong(int id, ArtistAllSongDTO params) async {
    print(params.order.name);
    final results = await Future.wait([
      dio.get('$baseUrl/artist/songs?id=$id&order=${params.order.name}&limit=${params.limit}&offset=${params.offset}'),
    ]);
    final response = results[0];
    return ArtistAllSongModel.fromJson(response.data);
  }
}