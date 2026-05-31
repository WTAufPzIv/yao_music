import 'package:yao_music/models/search.dart';

import '../models/song_detail.dart';
import 'constants.dart';
import 'home_api.dart';

class SongApi {
  /// 获取歌曲播放链接
  static Future<String> fetchSongDetail(SongDTO params) async {
    final results = await dio.get('$gdMusicUrl?types=url&source=${params.platform.name}&id=${params.id}&br=320');
    print(results.data.runtimeType);
    return params.platform == SearchPlatform.bilibili ? 'https://music-proxy.gdstudio.org/${results.data['url']}' : results.data['url'];
  }
  /// 获取网易云歌曲详情
  static Future<String> fetchSongAlbumCover(SongAlbumDTO params) async {
    final results = await dio.get('$gdMusicUrl?types=pic&source=${params.platform.name}&id=${params.picId}');
    print(results.data.runtimeType);
    return results.data['url'];
  }
}