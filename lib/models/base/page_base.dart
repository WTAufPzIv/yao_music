class PageData<T> {
  /// 当前页数据
  final List<T> list;
  /// 是否还有更多
  final bool more;

  const PageData({
    required this.list,
    required this.more,
  });
}

class PageDTO {
  final int limit;
  final int offset;

  const PageDTO({
    required this.limit,
    required this.offset,
  });
}