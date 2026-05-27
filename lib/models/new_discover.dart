import 'package:yao_music/models/artist_base.dart';

class ArtistModel implements ArtistBaseModel {
  @override
  final int id;
  @override
  final String name;
  ArtistModel({
    required this.id,
    required this.name,
  });
  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class NewDiscoverModel {
  /// id
  final int id;
  /// 标题
  final String name;
  /// 图片
  final String image;
  /// 歌手
  final List artists;
  /// 专辑
  final String album;
  String get artistNames {
    return artists
        .map((e) => e.name)
        .join(' / ');
  }
  NewDiscoverModel({
    required this.id,
    required this.name,
    required this.image,
    required this.artists,
    required this.album,
  });
  /// JSON -> Model
  factory NewDiscoverModel.fromJson(Map<String, dynamic> json) {
    return NewDiscoverModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['album']?['picUrl'] ?? '',
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => ArtistModel.fromJson(e))
          .toList() ?? [],
      album: json['album']?['name'] ?? '',
    );
  }
}