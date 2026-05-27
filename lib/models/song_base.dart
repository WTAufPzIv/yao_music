import 'album_base.dart';
import 'artist_base.dart';

abstract class SongBaseModel {
  int get id;
  String get name;
  AlbumBaseModel get album;
  List<ArtistBaseModel> get artistList;
  String get artistNames;
}