import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MusicAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer player;

  Future<void> Function()? onNext;
  Future<void> Function()? onPrevious;

  void _broadcastState(PlayerState state) {
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          state.playing
              ? MediaControl.pause
              : MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [
          0,
          1,
          2,
        ],
        processingState: _mapProcessingState(state.processingState),
        playing: state.playing,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
      ),
    );
  }

  MusicAudioHandler(this.player) {
    player.playerStateStream.listen(_broadcastState);

    player.positionStream.listen((_) {
      _broadcastState(
        player.playerState,
      );
    });
  }

  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  @override
  Future<void> play() =>
      player.play();

  @override
  Future<void> pause() =>
      player.pause();

  @override
  Future<void> seek(
      Duration position,
      ) =>
      player.seek(position);

  @override
  Future<void> skipToNext() async {
    await onNext?.call();
  }

  @override
  Future<void> skipToPrevious() async {
    await onPrevious?.call();
  }
}