import 'package:yao_music/models/search.dart';

class SingMiniInfo {
  final String id;
  final SearchPlatform platform;
  final String name;
  final String artistName;
  final String albumName;
  final String? coverUrl;
  final String? picId;
  final String? lyricId;

  const SingMiniInfo({
    required this.id,
    required this.platform,
    required this.name,
    required this.artistName,
    required this.albumName,
    this.coverUrl,
    this.picId,
    this.lyricId
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'platform': platform.name,
    'name': name,
    'picId': picId,
    'lyricId': lyricId,
    'artistName': artistName,
    'albumName': albumName,
    'coverUrl': coverUrl,
  };

  factory SingMiniInfo.fromJson(Map<String, dynamic> json) {
    final SingMiniInfo temp = SingMiniInfo(
      id: json['id'] ?? 0,
      platform: SearchPlatform.values.firstWhere(
            (e) => e.name == (json['platform'] ?? 'netease'),
        orElse: () => SearchPlatform.netease,
      ),
      name: json['name'] ?? '',
      artistName: json['artistName'] ?? '',
      albumName: json['albumName'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      picId: json['picId'] ?? '',
      lyricId: json['lyricId'],
    );
    return temp;
  }
}

class SongDetailModel extends SingMiniInfo {
  final String url;
  final Map<String, dynamic>? info;

  const SongDetailModel({
    required this.url,
    required super.id,
    required super.platform,
    required super.name,
    required super.artistName,
    required super.albumName,
    this.info,
  });

  factory SongDetailModel.fromJson(Map<String, dynamic> json) {
    final SongDetailModel temp = SongDetailModel(
      id: json['id'] ?? 0,
      platform: json['platform'] ?? SearchPlatform.netease,
      url: json['url'] ?? '',
      name: json['name'] ?? '',
      artistName: json['artistName'] ?? '',
      albumName: json['albumName'] ?? '',
      info: json['info'] ?? {},
    );
    return temp;
  }
}

class SongDTO  {
  final SearchPlatform platform;
  final String id;

  SongDTO({
    required this.platform,
    required this.id,
  });
}

class SongAlbumDTO  {
  final SearchPlatform platform;
  final String picId;

  SongAlbumDTO({
    required this.platform,
    required this.picId,
  });
}

class SongLyricDTO  {
  final SearchPlatform platform;
  final String lyricId;

  SongLyricDTO({
    required this.platform,
    required this.lyricId,
  });
}