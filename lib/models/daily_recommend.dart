import 'package:yao_music/models/song_base.dart';

import 'album_base.dart';
import 'artist_base.dart';

class AlbumOfDailyRecommend implements AlbumBaseModel {
  /// 专辑id
  @override
  final int id;
  /// 专辑名称
  @override
  final String name;
  /// 专辑封面
  @override
  final String picUrl;

  AlbumOfDailyRecommend({
    required this.id,
    required this.name,
    required this.picUrl
  });

  factory AlbumOfDailyRecommend.fromJson(Map<String, dynamic> json) {
    return AlbumOfDailyRecommend(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      picUrl: json['picUrl'] ?? '',
    );
  }
}

class ArtistOfDailyRecommend implements ArtistBaseModel {
  /// 歌手id
  @override
  final int id;
  /// 歌手名称
  @override
  final String name;

  ArtistOfDailyRecommend({
    required this.name,
    required this.id
  });

  factory ArtistOfDailyRecommend.fromJson(Map<String, dynamic> json) {
    return ArtistOfDailyRecommend(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class DailyRecommendModel implements SongBaseModel {
  /// 歌曲id
  @override
  final int id;
  /// 歌名
  @override
  final String name;
  /// 专辑信息
  @override
  final AlbumOfDailyRecommend album;
  /// 歌手信息
  @override
  final List<ArtistOfDailyRecommend> artistList;
  @override
  String get artistNames {
    return artistList
        .map((e) => e.name)
        .join(' / ');
  }

  DailyRecommendModel({
    required this.id,
    required this.name,
    required this.album,
    required this.artistList
  });

  factory DailyRecommendModel.fromJson(Map<String, dynamic> json) {
    return DailyRecommendModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      album: AlbumOfDailyRecommend.fromJson(json['al']),
      artistList: (json['ar'] as List<dynamic>?)
          ?.map((e) => ArtistOfDailyRecommend.fromJson(e))
          .toList() ?? [],
    );
  }
}