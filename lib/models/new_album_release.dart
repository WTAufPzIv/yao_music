import 'package:yao_music/models/base/album_base.dart';
import 'package:yao_music/models/base/artist_base.dart';

class ArtistOfNewAlbumReleaseModel implements ArtistBaseModel {
  /// 歌手id
  @override
  final int id;
  /// 歌手名称
  @override
  final String name;

  ArtistOfNewAlbumReleaseModel({
    required this.name,
    required this.id
  });

  factory ArtistOfNewAlbumReleaseModel.fromJson(Map<String, dynamic> json) {
    return ArtistOfNewAlbumReleaseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class NewAlbumReleaseModel implements AlbumBaseModel {
  /// 专辑id
  @override
  final int id;
  /// 专辑名称
  @override
  final String name;
  /// 专辑封面
  @override
  final String picUrl;
  /// 专辑歌手
  final List<ArtistOfNewAlbumReleaseModel> artistList;

  String get artistNames {
    return artistList
        .map((e) => e.name)
        .join(' / ');
  }

  NewAlbumReleaseModel({
    required this.id,
    required this.name,
    required this.artistList,
    required this.picUrl
  });

  factory NewAlbumReleaseModel.fromJson(Map<String, dynamic> json) {
    return NewAlbumReleaseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      picUrl: json['picUrl'] ?? '',
      artistList: (json['artists'] as List<dynamic>?)
          ?.map((e) => ArtistOfNewAlbumReleaseModel.fromJson(e))
          .toList() ?? [],
    );
  }
}