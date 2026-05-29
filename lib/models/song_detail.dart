import 'package:yao_music/models/search.dart';

class SingMiniInfo {
  final int id;
  final SearchPlatform platform;
  final String name;
  final String artistName;
  final String albumName;
  final String coverUrl;
  final Map<String, dynamic>? info;

  const SingMiniInfo({
    required this.id,
    required this.platform,
    required this.name,
    required this.artistName,
    required this.albumName,
    required this.coverUrl,
    this.info,
  });

  factory SingMiniInfo.fromJson(Map<String, dynamic> json) {
    final SingMiniInfo temp = SingMiniInfo(
      id: json['id'] ?? 0,
      platform: json['platform'] ?? SearchPlatform.netease,
      name: json['name'] ?? '',
      artistName: json['artistName'] ?? '',
      albumName: json['albumName'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      info: json['info'] ?? {},
    );
    return temp;
  }
}

class SongDetailModel extends SingMiniInfo {
  final String url;

  const SongDetailModel({
    required this.url,
    required super.id,
    required super.platform,
    required super.name,
    required super.artistName,
    required super.albumName,
    required super.coverUrl,
    super.info,
  });

  factory SongDetailModel.fromJson(Map<String, dynamic> json) {
    final SongDetailModel temp = SongDetailModel(
      id: json['id'] ?? 0,
      platform: json['platform'] ?? SearchPlatform.netease,
      url: json['url'] ?? '',
      name: json['name'] ?? '',
      artistName: json['artistName'] ?? '',
      albumName: json['albumName'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      info: json['info'] ?? {},
    );
    return temp;
  }
}

class SongDTO  {
  final SearchPlatform platform;
  final int id;

  SongDTO({
    required this.platform,
    required this.id,
  });
}