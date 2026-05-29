import '../api/song_api.dart';
import '../models/song_detail.dart';

class SongDetailService {
  /// 获取歌曲播放链接
  static Future<String> getSongDetail(SongDTO params) async {
    final result = await SongApi.fetchSongDetail(params);
    return result;
  }
}