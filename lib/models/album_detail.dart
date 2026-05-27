import 'package:yao_music/models/base/album_base.dart';
import 'package:yao_music/models/base/artist_base.dart';
import 'package:yao_music/models/base/song_base.dart';

class AlbumOfAlbumDetail implements AlbumBaseModel {
  @override
  final int id;
  @override
  final String name;
  @override
  final String picUrl;

  AlbumOfAlbumDetail({
    required this.id,
    required this.name,
    required this.picUrl,
  });

  factory AlbumOfAlbumDetail.fromJson(Map<String, dynamic> json) {
    return AlbumOfAlbumDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      picUrl: json['picUrl'] ?? ''
    );
  }
}

class ArtistOfAlbumDetail implements ArtistBaseModel {
  @override
  final int id;
  @override
  final String name;

  ArtistOfAlbumDetail({
    required this.id,
    required this.name,
  });

  factory ArtistOfAlbumDetail.fromJson(Map<String, dynamic> json) {
    return ArtistOfAlbumDetail(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
    );
  }
}

class SongsOfAlbumDetail implements SongBaseModel {
  @override
  final int id;
  @override
  final String name;
  @override
  final AlbumOfAlbumDetail album;
  @override
  final List<ArtistOfAlbumDetail> artistList;
  @override
  String get artistNames {
    return artistList
        .map((e) => e.name)
        .join(' / ');
  }

  SongsOfAlbumDetail({
    required this.id,
    required this.name,
    required this.album,
    required this.artistList
  });

  factory SongsOfAlbumDetail.fromJson(Map<String, dynamic> json) {
    return SongsOfAlbumDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      album: AlbumOfAlbumDetail.fromJson(json['al']),
      artistList: (json['ar'] as List<dynamic>?)
          ?.map((e) => ArtistOfAlbumDetail.fromJson(e))
          .toList() ?? [],
    );
  }
}

class AlbumDetailModel implements AlbumBaseModel {
  @override
  final int id;
  @override
  final String name;
  @override
  final String picUrl;
  final List<SongsOfAlbumDetail> song;
  final List<ArtistOfAlbumDetail> artistList;
  final String description;
  final int publishTime;
  final String company;
  String get artistNames {
    return artistList
        .map((e) => e.name)
        .join(' / ');
  }

  AlbumDetailModel({
    required this.id,
    required this.name,
    required this.picUrl,
    required this.song,
    required this.artistList,
    required this.description,
    required this.publishTime,
    required this.company
  });

  factory AlbumDetailModel.fromJson(Map<String, dynamic> json) {
    return AlbumDetailModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      picUrl: json['picUrl'] ?? '',
      description: json['description'] ?? '',
      publishTime: json['publishTime'] ?? '',
      company: json['company'] ?? '',
      song: (json['song'] as List<dynamic>?)
          ?.map((e) => SongsOfAlbumDetail.fromJson(e))
          .toList() ?? [],
      artistList: (json['artistList'] as List<dynamic>?)
            ?.map((e) => ArtistOfAlbumDetail.fromJson(e))
            .toList() ?? [],
    );
  }
}