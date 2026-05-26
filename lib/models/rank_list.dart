class RankListModel {
  final int id;
  final String name;
  final String coverImgUrl;

  RankListModel({
    required this.id,
    required this.name,
    required this.coverImgUrl
  });

  factory RankListModel.fromJson(Map<String, dynamic> json) {
    return RankListModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      coverImgUrl: json['coverImgUrl'] ?? '',
    );
  }
}