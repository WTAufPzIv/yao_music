import '../models/base/page_base.dart';
import '../models/search.dart';
import '../services/search_service.dart';
import 'base/base_page_provider.dart';

class SearchProvider extends BasePageProvider<SearchResultItem> {
  String keywords = "";
  SearchPlatform platform = SearchPlatform.netease;

  void changeKeyWords (String newLeyWord) {
    notifyListeners();
    keywords = newLeyWord;
    notifyListeners();
    refresh();
  }

  void changePlatForm (SearchPlatform newPlatForm) {
    notifyListeners();
    platform = newPlatForm;
    notifyListeners();
    if (keywords.isNotEmpty) {
      refresh();
    }
  }

  @override
  Future<PageData<SearchResultItem>> fetchData({
    required int offset,
    required int limit,
  }) async {
    final result = await SearchService.getSearch(SearchDTO(
      keywords: keywords,
      platform: platform,
      limit: limit,
      offset: offset
    ));
    return PageData(list: result.search, more: result.search.isNotEmpty && result.search.length >= limit);
  }
}