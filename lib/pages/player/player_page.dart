import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/constants/load_state.dart';

import '../../components/playerProgressBar.dart';
import '../../components/player_time_text.dart';
import '../../providers/song_detail_provider.dart';
import '../../providers/song_handle/player_manager.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({ super.key });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 20,
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  IconData getPlayModeIcon(PlayMode mode) {
    switch (mode) {
      case PlayMode.sequence:
        return CupertinoIcons.repeat;

      case PlayMode.shuffle:
        return CupertinoIcons.shuffle;

      case PlayMode.repeatOne:
        return CupertinoIcons.repeat_1;
    }
  }

  Color getPlayModeColor(PlayMode mode) {
    switch (mode) {
      case PlayMode.sequence:
        return Colors.white54;

      case PlayMode.shuffle:
        return Colors.redAccent;

      case PlayMode.repeatOne:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongDetailProvider>();
    final player = provider.player;
    final song = provider.currentBaseInfo;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// 顶部栏
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "正在播放",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 30),
            /// 专辑封面
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (_, snapshot) {
                final playing =
                    snapshot.data?.playing ?? false;
                if (playing) {
                  if (!_rotationController.isAnimating) {
                    _rotationController.repeat();
                  }
                } else {
                  _rotationController.stop();
                }
                return RotationTransition(
                  turns: _rotationController,
                  child: _buildAlbumCover(),
                );
              },
            ),
            const SizedBox(height: 40),
            /// 歌曲信息
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.name,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          song.artistName,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<SongDetailProvider>(
                    builder: (_, provider, __) {
                      final mode = provider.playMode;
                      return IconButton(
                        onPressed: () {
                          provider.togglePlayMode();
                        },
                        icon: Icon(
                          getPlayModeIcon(mode),
                          color: getPlayModeColor(mode),
                          size: 26,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            /// 进度条
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                children: [
                  PlayerSlider(
                    player: player,
                  ),
                  PlayerTime(
                    player: player,
                  ),
                ],
              ),
            ),
            const Spacer(),
            /// 控制按钮
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: provider.pre,
                    iconSize: 36,
                    icon: const Icon(
                      CupertinoIcons.backward_fill,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  provider.loadState == LoadState.loading ? SizedBox(
                    width: 82,
                    height: 82,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ) : StreamBuilder<PlayerState>(
                    stream: player.playerStateStream,
                    builder: (_, snapshot) {
                      final state = snapshot.data;
                      final processingState = state?.processingState;
                      final playing = snapshot.data?.playing ?? false;
                      if (
                          processingState == ProcessingState.loading
                          || processingState == ProcessingState.buffering
                      ) {
                        return const SizedBox(
                          width: 82,
                          height: 82,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: 82,
                          height: 82,
                          decoration:
                          const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed:
                            provider.togglePlay,
                            iconSize: 42,
                            icon: Icon(
                              playing
                                  ? CupertinoIcons
                                  .pause_fill
                                  : CupertinoIcons
                                  .play_fill,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: provider.next,
                    iconSize: 36,
                    icon: const Icon(
                      CupertinoIcons.forward_fill,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumCover() {
    final provider = context.read<SongDetailProvider>();
    final cover = provider.currentCoverImage;

    return Container(
      width: 320,
      height: 320,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// 黑胶纹路
          ...List.generate(20, (index) {
            return Container(
              width: 320 - index * 10,
              height: 320 - index * 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            );
          }),
          /// 专辑封面
          ClipOval(
            child: cover.isNotEmpty
                ? CachedNetworkImage(
                  imageUrl: cover,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  httpHeaders: const {
                    "user-agent": "windows",
                  },
                ) : Image.asset(
                  "lib/assets/image/album_default.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          ),
          /// 唱片中心孔
          /// 中心孔
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          )
        ],
      )
    );
  }
}

