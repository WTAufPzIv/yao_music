import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yao_music/theme/app_color.dart';

class PlayerSlider extends StatelessWidget {

  final AudioPlayer player;
  static const Duration _positionMinUpdateInterval = Duration(milliseconds: 300);
  static const Duration _positionMaxUpdateInterval = Duration(milliseconds: 500);

  const PlayerSlider({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      builder: (_, durationSnapshot) {
        final duration =
            durationSnapshot.data ??
                Duration.zero;
        return StreamBuilder<Duration>(
          stream: player.createPositionStream(
            minPeriod: _positionMinUpdateInterval,
            maxPeriod: _positionMaxUpdateInterval,
          ),
          builder: (_, positionSnapshot) {
            final position =
                positionSnapshot.data ??
                    Duration.zero;
            return Slider(
              activeColor: YMusicColors.primary,
              value: position.inMilliseconds.clamp(
                0,
                duration.inMilliseconds,
              ).toDouble(),
              max: duration.inMilliseconds == 0
                  ? 1
                  : duration.inMilliseconds
                  .toDouble(),
              onChanged: (value) {
                player.seek(
                  Duration(
                    milliseconds:
                    value.toInt(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
