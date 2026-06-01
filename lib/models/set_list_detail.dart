import 'package:yao_music/models/base/album_base.dart';
import 'package:yao_music/models/base/artist_base.dart';
import 'package:yao_music/models/base/song_base.dart';

class ArtistOfSetListSong implements ArtistBaseModel {
  /// 歌手id
  @override
  final int id;
  /// 歌手名称
  @override
  final String name;

  ArtistOfSetListSong({
    required this.name,
    required this.id
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ArtistOfSetListSong.fromJson(Map<String, dynamic> json) {
    return ArtistOfSetListSong(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class AlbumOfSetListSong implements AlbumBaseModel {
  /// 专辑id
  @override
  final int id;
  /// 专辑名称
  @override
  final String name;
  /// 专辑图片
  @override
  final String picUrl;

  AlbumOfSetListSong({
    required this.name,
    required this.id,
    required this.picUrl
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'picUrl': picUrl
    };
  }

  factory AlbumOfSetListSong.fromJson(Map<String, dynamic> json) {
    return AlbumOfSetListSong(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      picUrl: json['picUrl'] ?? '',
    );
  }
}

class SetListDetailSongsModel implements SongBaseModel {
  /// 歌曲id
  @override
  final int id;
  /// 歌名
  @override
  final String name;
  /// 歌手信息
  @override
  final List<ArtistOfSetListSong> artistList;
  // 专辑信息
  @override
  final AlbumOfSetListSong album;
  @override
  String get artistNames {
    return artistList
        .map((e) => e.name)
        .join(' / ');
  }

  SetListDetailSongsModel({
    required this.id,
    required this.name,
    required this.artistList,
    required this.album
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ar': artistList.map((e) => e.toJson()).toList(),
      'al': album.toJson(),
    };
  }

  factory SetListDetailSongsModel.fromJson(Map<String, dynamic> json) {
    return SetListDetailSongsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      artistList: (json['ar'] as List<dynamic>?)
          ?.map((e) => ArtistOfSetListSong.fromJson(e))
          .toList() ?? [],
      album: AlbumOfSetListSong.fromJson(json['al'])
    );
  }
}

class SetListDetailModel {
  /// id
  final int id;
  /// 歌单名称
  final String name;
  /// 歌单封面
  final String coverImgUrl;
  /// 描述
  final String description;
  /// 更新时间
  final int updateTime;
  /// 歌曲列表
  final List<SetListDetailSongsModel> songs;

  SetListDetailModel({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    required this.description,
    required this.updateTime,
    required this.songs
  });

  factory SetListDetailModel.fromJson(Map<String, dynamic> json) {
    return SetListDetailModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      coverImgUrl: json['coverImgUrl'] ?? '',
      description: json['description'] ?? '',
      updateTime: json['updateTime'] ?? '',
      songs: (json['songs'] as List<dynamic>?)
          ?.map((e) => SetListDetailSongsModel.fromJson(e))
          .toList() ?? [],
    );
  }
}

class LocalSetListDetailModel {
  /// id
  final int id;
  /// 歌单名称
  final String name;
  /// 歌曲列表
  final List<SetListDetailSongsModel> songs;

  LocalSetListDetailModel({
    required this.id,
    required this.name,
    required this.songs
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'songs': songs.map((e) => e.toJson()).toList(),
    };
  }

  factory LocalSetListDetailModel.fromJson(Map<String, dynamic> json) {
    return LocalSetListDetailModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      songs: (json['songs'] as List<dynamic>?)
          ?.map((e) => SetListDetailSongsModel.fromJson(e))
          .toList() ?? [],
    );
  }
}