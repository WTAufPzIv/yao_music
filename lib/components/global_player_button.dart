import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/player/player_page.dart';
import '../providers/song_detail_provider.dart';

class GlobalPlayerButton extends StatelessWidget {
  const GlobalPlayerButton({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<SongDetailProvider>(
      builder: (_, player, __) {
        if (!player.visible) {
          return const SizedBox();
        }
        return Positioned(
          right: 20,
          bottom: 100,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PlayerPage(),
                ),
              );
            },
            child: Container(
              width: 64,
              height: 64,

              decoration: BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: Icon(
                player.playing
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
        );
      },
    );
  }
}