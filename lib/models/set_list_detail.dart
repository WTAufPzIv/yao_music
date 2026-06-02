import 'package:yao_music/models/base/album_base.dart';
import 'package:yao_music/models/base/artist_base.dart';
import 'package:yao_music/models/base/song_base.dart';
import 'package:yao_music/models/search.dart';

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

  const AlbumOfSetListSong({
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

class LocalSetListDetailSongsModel {
  /// 歌曲i
  final int id;
  /// 歌名
  final String name;
  /// 平台
  final SearchPlatform platform;
  /// 歌手信息
  final List<ArtistOfSetListSong> artistList;
  // 专辑信息
  final AlbumOfSetListSong album;
  String get artistNames {
    return artistList
        .map((e) => e.name)
        .join(' / ');
  }

  const LocalSetListDetailSongsModel({
    required this.id,
    required this.name,
    required this.platform,
    this.artistList = const [],
    this.album = const AlbumOfSetListSong(
      id: -1,
      name: '',
      picUrl: '',
    ),
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'platform': platform.name,
      'artistList': artistList.map((e) => e.toJson()).toList(),
      'album': album.toJson(),
    };
  }

  factory LocalSetListDetailSongsModel.fromJson(Map<String, dynamic> json) {
    return LocalSetListDetailSongsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      platform: SearchPlatform.values.firstWhere(
        (e) => e.name == json['platform'],
        orElse: () => SearchPlatform.netease,
      ),

      artistList: json['artistList'] is List
          ? (json['artistList'] as List)
          .map((e) => ArtistOfSetListSong.fromJson(
        e as Map<String, dynamic>,
      ))
          .toList()
          : [],

      album: json['album'] != null
          ? AlbumOfSetListSong.fromJson(
        json['album'] as Map<String, dynamic>,
      )
          : AlbumOfSetListSong(
        id: -1,
        name: '',
        picUrl: '',
      ),
    );
  }
}

class LocalSetListDetailModel {
  /// id
  final int id;
  /// 歌单名称
  final String name;
  /// 歌曲列表
  final List<LocalSetListDetailSongsModel> songs;

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
          ?.map((e) => LocalSetListDetailSongsModel.fromJson(e))
          .toList() ?? [],
    );
  }
}