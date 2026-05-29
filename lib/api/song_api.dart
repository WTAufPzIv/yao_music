import '../models/song_detail.dart';
import 'constants.dart';
import 'home_api.dart';

class SongApi {
  /// 获取歌曲播放链接
  static Future<String> fetchSongDetail(SongDTO params) async {
    final results = await dio.get('$gdMusicUrl?types=url&source=${params.platform.name}&id=${params.id}&br=320');
    print(results.data.runtimeType);
    return results.data['url'];
  }
  /// 获取网易云歌曲详情
}