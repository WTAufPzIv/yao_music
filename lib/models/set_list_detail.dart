class ArtistOfSetListSong {
  /// 歌手id
  final int id;
  /// 歌手名称
  final String name;

  ArtistOfSetListSong({
    required this.name,
    required this.id
  });

  factory ArtistOfSetListSong.fromJson(Map<String, dynamic> json) {
    return ArtistOfSetListSong(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class SetListDetailSongsModel {
  /// 歌曲id
  final int id;
  /// 歌名
  final String name;
  /// 歌手信息
  final List<ArtistOfSetListSong> artistList;
  String get artistNames {
    return artistList
        .map((e) => e.name)
        .join(' / ');
  }

  SetListDetailSongsModel({
    required this.id,
    required this.name,
    required this.artistList
  });

  factory SetListDetailSongsModel.fromJson(Map<String, dynamic> json) {
    return SetListDetailSongsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      artistList: (json['ar'] as List<dynamic>?)
          ?.map((e) => ArtistOfSetListSong.fromJson(e))
          .toList() ?? [],
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