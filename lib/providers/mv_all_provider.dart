import '../models/base/page_base.dart';
import '../models/mv_all.dart';
import '../services/home_service.dart';
import 'base/base_page_provider.dart';

class MvAllProvider extends BasePageProvider<MvModel> {
  MvAllOrderType order = MvAllOrderType.hot;

  void changeOrder(MvAllOrderType newOrder) {
    order = newOrder;
    refresh();
    notifyListeners();
  }

  @override
  Future<PageData<MvModel>> fetchData({
    required int offset,
    required int limit,
  }) async {
    final result = await HomeService.getAllMvPage(MvAllDTO(order, offset: offset, limit: limit));
    return PageData(list: result.mv, more: result.more);
  }
}
