import 'package:yao_music/models/song_base.dart';

import 'album_base.dart';
import 'artist_base.dart';

class AlbumOfHotTop implements AlbumBaseModel {
  /// 专辑id
  @override
  final int id;
  /// 专辑名称
  @override
  final String name;
  /// 专辑封面
  @override
  final String picUrl;

  AlbumOfHotTop({
    required this.id,
    required this.name,
    required this.picUrl
  });

  factory AlbumOfHotTop.fromJson(Map<String, dynamic> json) {
    return AlbumOfHotTop(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      picUrl: json['picUrl'] ?? '',
    );
  }
}

class ArtistOfHotTop implements ArtistBaseModel {
  /// 歌手id
  @override
  final int id;
  /// 歌手名称
  @override
  final String name;

  ArtistOfHotTop({
    required this.name,
    required this.id
  });

  factory ArtistOfHotTop.fromJson(Map<String, dynamic> json) {
    return ArtistOfHotTop(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class HotTopModel implements SongBaseModel {
  /// 歌曲id
  @override
  final int id;
  /// 歌名
  @override
  final String name;
  /// 专辑信息
  @override
  final AlbumOfHotTop album;
  /// 歌手信息
  @override
  final List<ArtistOfHotTop> artistList;
  @override
  String get artistNames {
    return artistList
        .map((e) => e.name)
        .join(' / ');
  }

  HotTopModel({
    required this.id,
    required this.name,
    required this.album,
    required this.artistList
  });

  factory HotTopModel.fromJson(Map<String, dynamic> json) {
    return HotTopModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      album: AlbumOfHotTop.fromJson(json['al']),
      artistList: (json['ar'] as List<dynamic>?)
          ?.map((e) => ArtistOfHotTop.fromJson(e))
          .toList() ?? [],
    );
  }
}