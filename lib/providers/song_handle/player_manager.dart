import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/song_detail.dart';
import 'audio_handler.dart';

enum PlayMode {
  sequence,   // 顺序播放
  repeatOne,  // 单曲循环
  shuffle,    // 随机播放
}

final storage = FlutterSecureStorage();

class PlayerManager {
  PlayerManager._();
  static final PlayerManager instance = PlayerManager._();
  late final AudioPlayer player;
  late final MusicAudioHandler audioHandler;
  List<SingMiniInfo> playlist = [];
  int currentIndex = -1;
  PlayMode playMode = PlayMode.sequence;
  static const String playlistKey = 'play_list';
  static const String currentIndexKey = 'current_index';
  static const String playModeKey = 'play_mode';

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
    (audioHandler).onNext = () => nextSong();
    (audioHandler).onPrevious = () => previousSong();
    _playCurrentIndex();
  }

  void loadFromStorage () async {
    final playlistValue = await storage.read(key: playlistKey);
    playlist = playlistValue == null
        ? <SingMiniInfo>[]
        : (jsonDecode(playlistValue) as List).map((e) => SingMiniInfo.fromJson(e)).toList();
    final currentIndexValue = await storage.read(key: currentIndexKey);
    currentIndex = int.tryParse(currentIndexValue ?? '') ?? -1;
    final playModeValue = await storage.read(key: playModeKey);
    playMode = PlayMode.values.firstWhere(
          (e) => e.name == playModeValue,
      orElse: () => PlayMode.sequence,
    );
    if (playlist.isNotEmpty && currentIndex != -1) {
      _playCurrentIndex();
    }
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
    await storage.write(
      key: playlistKey,
      value: jsonEncode(
        playlist.map((e) => e.toJson()).toList(),
      ),
    );
    await storage.write(
      key: currentIndexKey,
      value: currentIndex.toString(),
    );
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
    print(onPlayRequest);
    if (onPlayRequest != null) {
      // audioHandler.pause();
      // player.seek(Duration.zero);
      await onPlayRequest!(
        song,
      );
    }
  }

  Future<void> _readyCurrentIndex() async {
    final song = playlist[currentIndex];
    if (onPlayRequest != null) {
      // audioHandler.pause();
      // player.seek(Duration.zero);
      await onPlayRequest!(
        song,
        justReady: true
      );
    }
  }

  VoidCallback? onPlaylistChanged;

  Future<void> Function(
      SingMiniInfo song,
      { bool? justReady }
      )? onPlayRequest;

  void togglePlayMode() async {
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
    await storage.write(
      key: playModeKey,
      value: playMode.name,
    );
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
        duration: player.duration,
      ),
    );
  }
}