import 'package:flutter/cupertino.dart';

import '../../constants/load_state.dart';
import '../../models/base/page_base.dart';

abstract class BasePageProvider<T> extends ChangeNotifier {
  List<T> list = [];
  int offset = 0;
  final int limit;
  bool more = true;
  LoadState loading = LoadState.loading;
  /// 是否首次加载
  bool initialized = false;
  /// 子类实现请求
  Future<PageData<T>> fetchData({
    required int offset,
    required int limit,
  });

  BasePageProvider({
    this.limit = 30,
  });

  /// 初始化
  Future<void> init() async {
    if (initialized) return;
    initialized = true;
    await refresh();
  }

  /// 下拉刷新 / 切换排序
  Future<void> refresh() async {
    offset = 0;
    more = true;
    list.clear();
    await _requestData(isRefresh: true);
  }

  /// 加载下一页
  Future<void> loadMore() async {
    if (loading == LoadState.loading || !more) return;
    loading = LoadState.loading;
    await _requestData();
  }

  /// 真正请求
  Future<void> _requestData({
    bool isRefresh = false,
  }) async {
    try {
      loading = LoadState.loading;
      notifyListeners();
      final result = await fetchData(
        offset: offset,
        limit: limit,
      );
      /// 刷新时重新赋值
      if (isRefresh) {
        list.clear();
      }
      list.addAll(result.list);
      more = result.more;
      /// offset推进
      offset += result.list.length;
      /// 空状态
      if (list.isEmpty) {
        loading = LoadState.empty;
      } else {
        loading = LoadState.success;
      }
    } catch (e) {
      /// 首次加载失败
      if (list.isEmpty) {
        loading = LoadState.error;
      }
    } finally {
      notifyListeners();
    }
  }
}