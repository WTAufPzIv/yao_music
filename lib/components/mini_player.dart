import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/player/player_page.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,

          PageRouteBuilder(

            transitionDuration: const Duration(
              milliseconds: 380,
            ),

            reverseTransitionDuration: const Duration(
              milliseconds: 300,
            ),

            pageBuilder: (_, animation, __) {

              return FadeTransition(
                opacity: animation,

                child: const PlayerPage(),
              );
            },

            transitionsBuilder:
                (_, animation, __, child) {

              final offsetAnimation = Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              );

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),

        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.92),

          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
        child: Row(
          children: [
            /// 封面
            ClipRRect(
              borderRadius: BorderRadius.circular(8),

              child: Image.network(
                "https://picsum.photos/200",
                width: 46,
                height: 46,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            /// 歌曲信息
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    "晴天",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "周杰伦",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            /// 播放按钮
            IconButton(
              onPressed: () {

              },

              icon: const Icon(
                CupertinoIcons.play_fill,
                color: Colors.white,
              ),
            ),

            /// 列表按钮
            IconButton(
              onPressed: () {

              },

              icon: const Icon(
                CupertinoIcons.music_note_list,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}