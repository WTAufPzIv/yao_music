import '../api/song_api.dart';
import '../models/song_detail.dart';

class SongDetailService {
  /// 获取歌曲播放链接
  static Future<String> getSongDetail(SongDTO params) async {
    final result = await SongApi.fetchSongDetail(params);
    return result;
  }
  /// 获取歌曲专辑图
  static Future<String> getSongAlbumCover(SongAlbumDTO params) async {
    final result = await SongApi.fetchSongAlbumCover(params);
    return result;
  }
  /// 获取歌词
  static Future<String> getSongAlbumLyric(SongLyricDTO params) async {
    final result = await SongApi.fetchSongLyric(params);
    return result;
  }
}