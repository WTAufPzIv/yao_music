class PersonalizedSetListModel {
  /// id
  final int id;
  /// 歌单名称
  final String name;
  /// 歌单封面
  final String picUrl;

  PersonalizedSetListModel({
    required this.id,
    required this.name,
    required this.picUrl
  });

  factory PersonalizedSetListModel.fromJson(Map<String, dynamic> json) {
    return PersonalizedSetListModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      picUrl: json['picUrl'] ?? '',
    );
  }
}