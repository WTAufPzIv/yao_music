import 'package:yao_music/models/base/artist_base.dart';
import 'package:yao_music/models/base/page_base.dart';

import 'base/album_base.dart';
import 'base/song_base.dart';

class AlbumOfArtistDetail implements AlbumBaseModel {
  @override
  final int id;
  @override
  final String name;
  @override
  final String picUrl;

  AlbumOfArtistDetail({
    required this.id,
    required this.name,
    required this.picUrl,
  });

  factory AlbumOfArtistDetail.fromJson(Map<String, dynamic> json) {
    return AlbumOfArtistDetail(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        picUrl: json['picUrl'] ?? ''
    );
  }
}

class ArtistOfArtistDetail implements ArtistBaseModel {
  @override
  final int id;
  @override
  final String name;

  ArtistOfArtistDetail({
    required this.id,
    required this.name,
  });

  factory ArtistOfArtistDetail.fromJson(Map<String, dynamic> json) {
    return ArtistOfArtistDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class SongsOfArtistDetail implements SongBaseModel {
  @override
  final int id;
  @override
  final String name;
  @override
  final AlbumOfArtistDetail album;
  @override
  final List<ArtistOfArtistDetail> artistList;
  @override
  String get artistNames {
    return artistList
        .map((e) => e.name)
        .join(' / ');
  }

  SongsOfArtistDetail({
    required this.id,
    required this.name,
    required this.album,
    required this.artistList
  });

  factory SongsOfArtistDetail.fromJson(Map<String, dynamic> json) {
    return SongsOfArtistDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      album: AlbumOfArtistDetail.fromJson(json['al']),
      artistList: (json['ar'] as List<dynamic>?)
          ?.map((e) => ArtistOfArtistDetail.fromJson(e))
          .toList() ?? [],
    );
  }
}

class IntroductionItem {
  final String ti;
  final String text;

  IntroductionItem({
    required this.ti,
    required this.text,
  });

  factory IntroductionItem.fromJson(Map<String, dynamic> json) {
    return IntroductionItem(
      ti: json['ti'] ?? 0,
      text: json['txt'] ?? '',
    );
  }
}

class ArtistDetailModel implements ArtistBaseModel {
  @override
  final int id;
  @override
  final String name;
  final String cover;
  final List<dynamic> transNames;
  final String briefDesc;
  final List<SongsOfArtistDetail> song;
  final List<AlbumOfArtistDetail> album;
  final List<IntroductionItem> introduction;
  String get joinTransNames {
    return transNames.join(' / ');
  }

  ArtistDetailModel({
    required this.id,
    required this.name,
    required this.cover,
    required this.transNames,
    required this.briefDesc,
    required this.song,
    required this.album,
    required this.introduction
  });

  factory ArtistDetailModel.fromJson(Map<String, dynamic> json) {
    return ArtistDetailModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      cover: json['cover'] ?? '',
      transNames: json['transNames'] ?? '',
      briefDesc: json['briefDesc'] ?? '',
      introduction: (json['introduction'] as List<dynamic>?)
          ?.map((e) => IntroductionItem.fromJson(e))
          .toList() ?? [],
      song: (json['song'] as List<dynamic>?)
          ?.map((e) => SongsOfArtistDetail.fromJson(e))
          .toList() ?? [],
      album: (json['album'] as List<dynamic>?)
          ?.map((e) => AlbumOfArtistDetail.fromJson(e))
          .toList() ?? [],
    );
  }
}

class ArtistAllSongModel {
  final List<SongsOfArtistDetail> song;
  final bool more;

  ArtistAllSongModel({
    required this.song,
    required this.more
  });

  factory ArtistAllSongModel.fromJson(Map<String, dynamic> json) {
    return ArtistAllSongModel(
      song: (json['songs'] as List<dynamic>?)
          ?.map((e) => SongsOfArtistDetail.fromJson(e))
          .toList() ?? [],
      more: json['more']
    );
  }
}

enum ArtistAllSongOrderType {
  hot,
  time
}

class ArtistAllSongDTO extends PageDTO {
  ArtistAllSongOrderType order = ArtistAllSongOrderType.hot;
  ArtistAllSongDTO(this.order, {required super.limit, required super.offset});
}

class ArtistAllAlbumModel {
  final List<AlbumOfArtistDetail> album;
  final bool more;

  ArtistAllAlbumModel({
    required this.album,
    required this.more
  });

  factory ArtistAllAlbumModel.fromJson(Map<String, dynamic> json) {
    return ArtistAllAlbumModel(
        album: (json['hotAlbums'] as List<dynamic>?)
            ?.map((e) => AlbumOfArtistDetail.fromJson(e))
            .toList() ?? [],
        more: json['more']
    );
  }
}

class ArtistAllAlbumDTO extends PageDTO {
  ArtistAllSongOrderType order = ArtistAllSongOrderType.hot;
  ArtistAllAlbumDTO(this.order, {required super.limit, required super.offset});
}