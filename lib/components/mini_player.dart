import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../pages/player/player_page.dart';
import '../providers/song_detail_provider.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({ super.key });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongDetailProvider>();
    final currentBaseInfo = provider.currentBaseInfo;
    final currentCoverImage = provider.currentCoverImage;
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
              child: currentCoverImage.isNotEmpty ? CachedNetworkImage(
                imageUrl: currentCoverImage,
                width: 46,
                height: 46,
                fit: BoxFit.cover,
                httpHeaders: { "user-agent": 'windows' },
              ) : Image.asset(
                "lib/assets/image/album_default.png",
                width: 46,
                height: 46,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            /// 歌曲信息
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentBaseInfo.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentBaseInfo.artistName,
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
            _PlayButton(provider: provider),
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

class _PlayButton extends StatelessWidget {

  final SongDetailProvider provider;

  const _PlayButton({
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<PlayerState>(
      stream: provider.player.playerStateStream,
      builder: (_, snapshot) {
        final state = snapshot.data;
        final processingState = state?.processingState;
        final playing = state?.playing ?? false;
        /// 加载中
        if (processingState ==
            ProcessingState.loading ||
            processingState ==
                ProcessingState.buffering) {
          return const SizedBox(
            width: 48,
            height: 48,
            child: Padding(
              padding: EdgeInsets.all(12),
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }

        return IconButton(
          onPressed: provider.togglePlay,
          icon: Icon(
            playing
                ? CupertinoIcons.pause_fill
                : CupertinoIcons.play_fill,
            color: Colors.white,
          ),
        );
      },
    );
  }
}