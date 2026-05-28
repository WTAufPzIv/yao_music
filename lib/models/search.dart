import 'package:yao_music/models/base/page_base.dart';

class SearchResultItem {
  final int id;
  final String name;
  final List<String> artist;
  final String album;

  SearchResultItem({
    required this.id,
    required this.name,
    required this.artist,
    required this.album,
  });

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      album: json['album'] ?? '',
      artist: json['artist']
    );
  }
}

class SearchModel {
  final List<SearchResultItem> search;

  SearchModel({
    required this.search,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      search: (json['search'] as List<dynamic>?)
          ?.map((e) => SearchResultItem.fromJson(e))
          .toList() ?? [],
    );
  }
}

enum SearchPlatform {
  netease,
  kuwo,
  bilibili
}

class SearchDTO extends PageDTO {
  final SearchPlatform platform;
  final String keywords;

  SearchDTO({
    required this.keywords,
    required this.platform,
    required super.limit,
    required super.offset
  });
}