import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/song_detail.dart';
import 'audio_handler.dart';

enum PlayMode {
  sequence,   // 顺序播放
  repeatOne,  // 单曲循环
  shuffle,    // 随机播放
}

class PlayerManager {
  PlayerManager._();
  static final PlayerManager instance = PlayerManager._();
  late final AudioPlayer player;
  late final MusicAudioHandler audioHandler;
  List<SingMiniInfo> playlist = [];
  int currentIndex = -1;
  PlayMode playMode = PlayMode.sequence;

  Future<void> init() async {
    player = AudioPlayer();
    audioHandler = await AudioService.init(
      builder: () => MusicAudioHandler(player),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.mycompany.myapp.audio',
        androidNotificationChannelName: 'Music Playback',
        androidNotificationOngoing: true
      ),
    );
    _listenPlayer();
  }

  void _listenPlayer() {
    player.playerStateStream.listen((state) async {
        if (state.processingState == ProcessingState.completed) {
          await nextSong();
        }
      },
    );
  }
  bool get playing => player.playing;
  SingMiniInfo? get currentSong {
    if (currentIndex < 0 ||
        currentIndex >= playlist.length) {
      return null;
    }
    return playlist[currentIndex];
  }

  Future<void> pause() async {
    await audioHandler.pause();
  }

  Future<void> resume() async {
    await audioHandler.play();
  }

  Future<void> seek(Duration position,) async {
    await audioHandler.seek(position);
  }

  Future<void> setPlaylist({
    required List<SingMiniInfo> songs,
    required int startIndex,
  }) async {
    playlist = songs;
    currentIndex = startIndex;
    _playCurrentIndex();
  }

  Future<void> clearPlaylist() async {
    playlist = [];
    currentIndex = -1;
  }

  Future<void> playSong({
    required SingMiniInfo song,
    required String url,
    required String cover
  }) async {
    await player.setUrl(url);
    _updateMediaItem(song, cover);
    await audioHandler.play();
  }

  Future<void> nextSong() async {
    if (playlist.isEmpty) {
      player.seek(Duration.zero);
      audioHandler.pause();
      return;
    }
    switch (playMode) {
      case PlayMode.repeatOne:
        player.seek(Duration.zero);
        await audioHandler.play();
        return;
      case PlayMode.shuffle:
        currentIndex = Random().nextInt(playlist.length,);
        break;
      case PlayMode.sequence:
        currentIndex++;
        if (currentIndex >= playlist.length) {
          currentIndex = 0;
        }
        break;
    }
    await _playCurrentIndex();
  }

  Future<void> previousSong() async {
    if (playlist.isEmpty) {
      player.seek(Duration.zero);
      audioHandler.pause();
      return;
    }
    switch (playMode) {
      case PlayMode.shuffle:
        currentIndex = Random().nextInt(playlist.length);
        break;
      default:
        currentIndex--;
        if (currentIndex < 0) {
          currentIndex = playlist.length - 1;
        }
    }
    await _playCurrentIndex();
  }

  Future<void> _playCurrentIndex() async {
    final song = playlist[currentIndex];
    if (onPlayRequest != null) {
      audioHandler.pause();
      player.seek(Duration.zero);
      await onPlayRequest!(
        song,
      );
    }
  }

  VoidCallback? onPlaylistChanged;

  Future<void> Function(SingMiniInfo song, )? onPlayRequest;

  void togglePlayMode() {
    switch (playMode) {
      case PlayMode.sequence:
        playMode = PlayMode.repeatOne;
        break;
      case PlayMode.repeatOne:
        playMode = PlayMode.shuffle;
        break;
      case PlayMode.shuffle:
        playMode = PlayMode.sequence;
        break;
    }
    onPlaylistChanged?.call();
  }

  void _updateMediaItem(SingMiniInfo song, String cover) {
    audioHandler.mediaItem.add(
      MediaItem(
        id: song.id.toString(),
        title: song.name,
        artist: song.artistName,
        album: song.albumName,
        artUri: Uri.parse(cover),
        duration: player.duration
      ),
    );
  }
}