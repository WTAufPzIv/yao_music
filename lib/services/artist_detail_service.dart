import '../api/artist_detail.dart';
import '../models/artist_detail.dart';

class ArtistDetailService {
  /// 获取歌手详情
  static Future<ArtistDetailModel> getArtistDetail(int id) async {
    final result = await ArtistDetailApi.fetchArtistDetail(id);
    return result;
  }
  /// 获取歌手歌曲分页
  static Future<ArtistAllSongModel> getArtistAllSongPage(int id, ArtistAllSongDTO params) async {
    final result = await ArtistDetailApi.fetchArtistAllSong(id, params);
    return result;
  }
}