import '../api/search_api.dart';
import '../models/search.dart';

class SearchService {
  /// 搜索
  static Future<SearchModel> getSearch(SearchDTO params) async {
    final result = await SearchApi.fetchSearchSong(params);
    return result;
  }
}