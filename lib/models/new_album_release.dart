class ArtistOfNewAlbumReleaseModel {
  /// 歌手id
  final int id;
  /// 歌手名称
  final String name;

  ArtistOfNewAlbumReleaseModel({
    required this.name,
    required this.id
  });

  factory ArtistOfNewAlbumReleaseModel.fromJson(Map<String, dynamic> json) {
    return ArtistOfNewAlbumReleaseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class NewAlbumReleaseModel {
  /// 专辑id
  final int id;
  /// 专辑名称
  final String name;
  /// 专辑歌手
  final List<ArtistOfNewAlbumReleaseModel> artistList;
  /// 专辑封面
  final String picUrl;

  String get artistNames {
    return artistList
        .map((e) => e.name)
        .join(' / ');
  }

  NewAlbumReleaseModel({
    required this.id,
    required this.name,
    required this.artistList,
    required this.picUrl
  });

  factory NewAlbumReleaseModel.fromJson(Map<String, dynamic> json) {
    return NewAlbumReleaseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      picUrl: json['picUrl'] ?? '',
      artistList: (json['artists'] as List<dynamic>?)
          ?.map((e) => ArtistOfNewAlbumReleaseModel.fromJson(e))
          .toList() ?? [],
    );
  }
}