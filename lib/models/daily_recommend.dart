class AlbumOfDailyRecommend {
  /// 专辑id
  final int id;
  /// 专辑名称
  final String name;
  /// 专辑封面
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

class ArtistOfDailyRecommend {
  /// 歌手id
  final int id;
  /// 歌手名称
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

class DailyRecommendModel {
  /// 歌曲id
  final int id;
  /// 歌名
  final String name;
  /// 专辑信息
  final AlbumOfDailyRecommend album;
  /// 歌手信息
  final List<ArtistOfDailyRecommend> artistList;
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