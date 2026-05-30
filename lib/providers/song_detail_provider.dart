import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yao_music/constants/load_state.dart';
import 'package:yao_music/models/search.dart';

import '../components/global_player.dart';
import '../models/song_detail.dart';
import '../services/song_detail_service.dart';

class SongDetailProvider extends ChangeNotifier {
  SingMiniInfo currentBaseInfo = SingMiniInfo(
      id: 0,
      platform: SearchPlatform.netease,
      name: '没有正在播放的歌曲',
      artistName: '-',
      albumName: '-'
  );
  String currentUrl = '';
  String currentCoverImage = '';
  LoadState loadState = LoadState.loading;
  List<SingMiniInfo> playListIds = [];
  /// 当前是否显示播放器按钮
  bool visible = true;
  /// 播放器核心
  final AudioPlayer _player = GlobalPlayer.instance.player;
  AudioPlayer get player => _player;
  bool get playing => _player.playing;

  SongDetailProvider() {
    _listenPlayer();
  }

  void _listenPlayer() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // nextSong();
      }
    });
    notifyListeners();
  }

  Future<void> togglePlay() async {
    if (_player.playing) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
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

  Future<void> fetchUrlAndPlay(SingMiniInfo mini) async {
    if (mini.id == null || mini.id.isNaN) return;
    if (currentBaseInfo.id == mini.id) {
      if (!_player.playing) {
        await _player.play();
      }
      return;
    }
    currentBaseInfo = mini;
    try {
      notifyListeners();
      loadState = LoadState.loading;
      await fetchAlbumCover();
      final result = await SongDetailService.getSongDetail(SongDTO(
          id: currentBaseInfo.id,
          platform: currentBaseInfo.platform
      ));
      currentUrl = result;
      await _player.setUrl(currentUrl);
      await _player.play();
      visible = true;
      loadState = LoadState.success;
      notifyListeners();
    } catch (e) {
      loadState = LoadState.error;
      notifyListeners();
      rethrow;
    }
  }
}