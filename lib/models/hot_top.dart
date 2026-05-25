class AlbumOfHotTop {
  /// 专辑id
  final int id;
  /// 专辑名称
  final String name;
  /// 专辑封面
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

class ArtistOfHotTop {
  /// 歌手id
  final int id;
  /// 歌手名称
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

class HotTopModel {
  /// 歌曲id
  final int id;
  /// 歌名
  final String name;
  /// 专辑信息
  final AlbumOfHotTop album;
  /// 歌手信息
  final List<ArtistOfHotTop> artistList;
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