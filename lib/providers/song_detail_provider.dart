import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yao_music/constants/load_state.dart';
import 'package:yao_music/models/search.dart';
import 'package:yao_music/providers/song_handle/player_manager.dart';

import '../models/lyric_line.dart';
import '../models/song_detail.dart';
import '../services/song_detail_service.dart';

class SongDetailProvider extends ChangeNotifier {
  final PlayerManager _manager = PlayerManager.instance;
  SingMiniInfo currentBaseInfo = SingMiniInfo(
      id: '0',
      platform: SearchPlatform.netease,
      name: '没有正在播放的歌曲',
      artistName: '-',
      albumName: '-'
  );
  String currentUrl = '';
  String currentCoverImage = '';
  String currentLyricText = '';
  List<LyricLineModel> currentLyricPrase = [];
  bool visible = true;
  LoadState loadState = LoadState.success;
  AudioPlayer get player => _manager.player;
  PlayMode get playMode => _manager.playMode;
  bool get playing => _manager.playing;

  SongDetailProvider() {
    _manager.onPlayRequest = playSong;
    _manager.loadFromStorage();
  }

  Future<void> togglePlay() async {
    if (_manager.playing) {
      await _manager.pause();
    } else {
      await _manager.resume();
    }
  }

  List<LyricLineModel> parseLrc(String lrc) {
    final result = <LyricLineModel>[];
    final reg = RegExp(
      r'\[(\d+):(\d+)\.(\d+)\](.*)',
    );
    for (final line in lrc.split('\n')) {
      final match = reg.firstMatch(line);

      if (match == null) continue;

      final minute = int.parse(match.group(1)!);
      final second = int.parse(match.group(2)!);
      final milli =
      int.parse(match.group(3)!.padRight(3, '0'));

      result.add(
        LyricLineModel(
          time: Duration(
            minutes: minute,
            seconds: second,
            milliseconds: milli,
          ),
          text: match.group(4)!.trim(),
        ),
      );
    }

    return result;
  }

  Future<void> fetchLyricText() async {
    print(currentBaseInfo.toJson());
    if (currentBaseInfo.lyricId != null && currentBaseInfo.lyricId!.isNotEmpty) {
      try {
        final result = await SongDetailService.getSongAlbumLyric(SongLyricDTO(
            lyricId: currentBaseInfo.lyricId!,
            platform: currentBaseInfo.platform
        ));
        currentLyricText = result;
        currentLyricPrase = parseLrc(currentLyricText);
        return;
      } catch (e) {
        print(e);
        currentLyricPrase = [];
      }
    }
    currentLyricPrase = [];
  }

  Future<void> fetchAlbumCover() async {
    if (currentBaseInfo.coverUrl != null && currentBaseInfo.coverUrl!.isNotEmpty) {
      currentCoverImage = currentBaseInfo.coverUrl!;
      return;
    }
    if (currentBaseInfo.picId != null && currentBaseInfo.picId!.isNotEmpty) {
      try {
        final result = await SongDetailService.getSongAlbumCover(SongAlbumDTO(
            picId: currentBaseInfo.picId!,
            platform: currentBaseInfo.platform
        ));
        currentCoverImage = result;
        return;
      } catch (e) {
        currentCoverImage = '';
      }
    }
    currentCoverImage = '';
  }

  Future<void> playSong(SingMiniInfo mini, { bool? justReady = false }) async {
    if (mini.id == null || mini.id.isEmpty) return;
    if (currentBaseInfo.id == mini.id) {
      if (!_manager.playing) {
        await _manager.resume();
      }
      return;
    }
    currentBaseInfo = mini;
    try {
      loadState = LoadState.loading;
      notifyListeners();
      await fetchLyricText();
      await fetchAlbumCover();
      final result = await SongDetailService.getSongDetail(SongDTO(
          id: currentBaseInfo.id,
          platform: currentBaseInfo.platform
      ));
      if (result == null || result.isEmpty || result.length == 0) {
        loadState = LoadState.success;
        notifyListeners();
        return;
      }
      currentUrl = result;
      visible = true;
      loadState = LoadState.success;
      notifyListeners();
      if (justReady != null && justReady == true) {
        _manager.prePlaySong(
            song: mini,
            url: currentUrl,
            cover: currentCoverImage
        );
      } else {
        await _manager.playSong(
            song: mini,
            url: currentUrl,
            cover: currentCoverImage,
            lyrics: currentLyricPrase
        );
      }
    } catch (e) {
      loadState = LoadState.error;
      rethrow;
    }
  }

  void next() {
    _manager.nextSong();
  }

  void pre() {
    _manager.previousSong();
  }

  void togglePlayMode() {
    _manager.togglePlayMode();
    notifyListeners();
  }

  void setPlayListAndPlay(List<SingMiniInfo> minis, int? startIndex) {
    _manager.setPlaylist(songs: minis, startIndex: startIndex ?? 0);
  }
}