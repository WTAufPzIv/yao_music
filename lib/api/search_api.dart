import '../models/search.dart';
import 'constants.dart';
import 'home_api.dart';

class SearchApi {
  /// 搜索
  static Future<SearchModel> fetchSearchSong(SearchDTO params) async {
    print('$gdMusicUrl?types=search&source=${params.platform.name}&name=${params.keywords}&count=${params.limit}&pages=${params.offset / params.limit + 1}');
    final results = await Future.wait([
      dio.get('$gdMusicUrl?types=search&source=${params.platform.name}&name=${params.keywords}&count=${params.limit}&pages=${params.offset / params.limit + 1}'),
    ]);
    return SearchModel.fromJson({
      "search": results[0].data
    });
  }
}