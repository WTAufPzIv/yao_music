import 'base/page_base.dart';

class MvModel {
  final int id;
  final String cover;
  final String name;
  final String briefDesc;
  final int artistId;
  final String artistName;

  MvModel({
    required this.id,
    required this.cover,
    required this.name,
    required this.briefDesc,
    required this.artistId,
    required this.artistName,
  });

  factory MvModel.fromJson(Map<String, dynamic> json) {
    return MvModel(
      id: json['id'] ?? 0,
      cover: json['cover'] ?? '',
      name: json['name'] ?? '',
      briefDesc: json['briefDesc'] ?? '',
      artistId: json['artistId'] ?? '',
      artistName: json['artistName'] ?? '',
    );
  }
}

class MvAllModel {
  final List<MvModel> mv;
  final bool more;

  MvAllModel({
    required this.mv,
    required this.more
  });

  factory MvAllModel.fromJson(Map<String, dynamic> json) {
    return MvAllModel(
        mv: (json['data'] as List<dynamic>?)
            ?.map((e) => MvModel.fromJson(e))
            .toList() ?? [],
        more: json['hasMore']
    );
  }
}

enum MvAllOrderType {
  up,
  hot,
  newest,
}

extension MvAllOrderTypeExt on MvAllOrderType {
  String get name {
    switch (this) {
      case MvAllOrderType.up:
        return '上升最快';
      case MvAllOrderType.hot:
        return '最热';
      case MvAllOrderType.newest:
        return '最新';
    }
  }
}

class MvAllDTO extends PageDTO {
  MvAllOrderType order = MvAllOrderType.hot;
  MvAllDTO(this.order, {required super.limit, required super.offset});
}