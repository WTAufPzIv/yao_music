import 'package:yao_music/models/base/page_base.dart';

class SearchResultItem {
  final String id;
  final String name;
  final List<dynamic> artist;
  final String album;
  final String picId;
  String get artistNames {
    return artist.join(' / ');
  }

  SearchResultItem({
    required this.id,
    required this.name,
    required this.artist,
    required this.album,
    required this.picId
  });

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    final SearchResultItem temp = SearchResultItem(
      id: json['id'] ?? '0',
      name: json['name'] ?? '',
      album: json['album'] ?? '',
      picId: json['pic_id'] ?? '',
      artist: (json['artist'] as List<dynamic>).toList(),
    );
    return temp;
  }
}

class SearchModel {
  final List<SearchResultItem> search;

  SearchModel({
    required this.search,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    final SearchModel temp = SearchModel(
      search: (json['search'] as List<dynamic>?)
          ?.map((e) => SearchResultItem.fromJson(e))
          .toList() ?? [],
    );
    return temp;
  }
}

enum SearchPlatform {
  netease,
  joox,
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