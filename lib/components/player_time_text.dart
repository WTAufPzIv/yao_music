import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerTime extends StatelessWidget {

  final AudioPlayer player;
  static const Duration _positionUpdateInterval = Duration(seconds: 1);

  const PlayerTime({
    super.key,
    required this.player,
  });

  String format(Duration d) {

    final minutes =
    d.inMinutes
        .toString()
        .padLeft(2, '0');

    final seconds =
    (d.inSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

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
            minPeriod: _positionUpdateInterval,
            maxPeriod: _positionUpdateInterval,
          ),
          builder: (_, positionSnapshot) {

            final position =
                positionSnapshot.data ??
                    Duration.zero;

            return Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [

                Text(
                  format(position),
                  style:
                  const TextStyle(
                    color:
                    Colors.white54,
                  ),
                ),

                Text(
                  format(duration),
                  style:
                  const TextStyle(
                    color:
                    Colors.white54,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
