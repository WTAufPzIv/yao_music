import '../api/set_list_detail_api.dart';
import '../models/set_list_detail.dart';

class SetListDetailService {
  /// 获取歌单详情
  static Future<SetListDetailModel> getSetListDetail(int id) async {
    final result = await SetListDetailApi.fetchSetListDetail(id);
    return result;
  }
}