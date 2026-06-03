import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/constants/load_state.dart';

import '../../components/playerProgressBar.dart';
import '../../components/player_time_text.dart';
import '../../models/lyric_line.dart';
import '../../models/song_detail.dart';
import '../../providers/song_detail_provider.dart';
import '../../providers/song_handle/player_manager.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  static const double _lyricLineExtent = 58;

  late final AnimationController _rotationController;
  late final PageController _pageController;
  late final ScrollController _lyricScrollController;
  StreamSubscription<Duration>? _positionSubscription;
  int _currentLyricIndex = 0;
  String? _currentSongId;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _pageController = PageController(initialPage: 1);
    _lyricScrollController = ScrollController();
    _positionSubscription = context
        .read<SongDetailProvider>()
        .player
        .createPositionStream(
          minPeriod: const Duration(milliseconds: 300),
          maxPeriod: const Duration(milliseconds: 500),
        )
        .listen(_syncLyricWithPosition);
  }

  void _resetLyricStateIfNeeded(String songId) {
    if (_currentSongId == songId) {
      return;
    }

    _currentSongId = songId;
    _currentLyricIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_lyricScrollController.hasClients) {
        _lyricScrollController.jumpTo(0);
      }
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _pageController.dispose();
    _lyricScrollController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _syncLyricWithPosition(Duration position) {
    if (!mounted) {
      return;
    }

    final lyrics = context.read<SongDetailProvider>().currentLyricPrase;
    if (lyrics.isEmpty) {
      if (_currentLyricIndex != 0) {
        setState(() {
          _currentLyricIndex = 0;
        });
      }
      return;
    }

    final nextIndex = _findCurrentLyricIndex(lyrics, position);
    if (nextIndex == _currentLyricIndex) {
      return;
    }

    setState(() {
      _currentLyricIndex = nextIndex;
    });
    _scrollCurrentLyricIntoView(nextIndex);
  }

  int _findCurrentLyricIndex(
    List<LyricLineModel> lyrics,
    Duration position,
  ) {
    var low = 0;
    var high = lyrics.length - 1;
    var result = 0;

    while (low <= high) {
      final middle = low + ((high - low) >> 1);
      if (lyrics[middle].time.compareTo(position) <= 0) {
        result = middle;
        low = middle + 1;
      } else {
        high = middle - 1;
      }
    }

    return result;
  }

  void _scrollCurrentLyricIntoView(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_lyricScrollController.hasClients) {
        return;
      }

      final position = _lyricScrollController.position;
      final targetOffset = (index * _lyricLineExtent) -
          (position.viewportDimension / 2) +
          (_lyricLineExtent / 2);
      final safeOffset = targetOffset.clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );

      _lyricScrollController.animateTo(
        safeOffset.toDouble(),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
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
    _resetLyricStateIfNeeded(song.id);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
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
                    '正在播放',
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
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  _buildLyricPage(provider),
                  _buildAlbumPage(player, song),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  PlayerSlider(player: player),
                  PlayerTime(player: player),
                ],
              ),
            ),
            const SizedBox(height: 28),
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
                  provider.loadState == LoadState.loading
                      ? const SizedBox(
                          width: 82,
                          height: 82,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : StreamBuilder<PlayerState>(
                          stream: player.playerStateStream,
                          builder: (_, snapshot) {
                            final state = snapshot.data;
                            final processingState = state?.processingState;
                            final playing = snapshot.data?.playing ?? false;
                            if (processingState == ProcessingState.loading ||
                                processingState ==
                                    ProcessingState.buffering) {
                              return const SizedBox(
                                width: 82,
                                height: 82,
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }

                            return Container(
                              width: 82,
                              height: 82,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: provider.togglePlay,
                                iconSize: 42,
                                icon: Icon(
                                  playing
                                      ? CupertinoIcons.pause_fill
                                      : CupertinoIcons.play_fill,
                                  color: Colors.black,
                                ),
                              ),
                            );
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

  Widget _buildAlbumPage(
    AudioPlayer player,
    SingMiniInfo song,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final coverSize =
            (constraints.maxHeight * 0.56).clamp(220.0, 320.0).toDouble();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (_, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                if (playing) {
                  if (!_rotationController.isAnimating) {
                    _rotationController.repeat();
                  }
                } else {
                  _rotationController.stop();
                }
                return RotationTransition(
                  turns: _rotationController,
                  child: _buildAlbumCover(coverSize),
                );
              },
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          song.artistName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
          ],
        );
      },
    );
  }

  Widget _buildLyricPage(SongDetailProvider provider) {
    final lyrics = provider.currentLyricPrase;
    if (provider.loadState == LoadState.loading) {
      return const Center(
        child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white70,
          ),
        ),
      );
    }

    if (lyrics.isEmpty) {
      return const Center(
        child: Text(
          '暂无歌词',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 18,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _lyricScrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: 34,
        vertical: 28,
      ),
      itemExtent: _lyricLineExtent,
      itemCount: lyrics.length,
      itemBuilder: (context, index) {
        final line = lyrics[index];
        final active = index == _currentLyricIndex;
        return AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            color: active ? Colors.white : Colors.white38,
            fontSize: active ? 22 : 18,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            height: 1.25,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              line.text.isEmpty ? '...' : line.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumCover(double size) {
    final provider = context.read<SongDetailProvider>();
    final cover = provider.currentCoverImage;
    final ringStep = size / 32;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(20, (index) {
            final ringSize = size - index * ringStep;
            return Container(
              width: ringSize,
              height: ringSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            );
          }),
          ClipOval(
            child: cover.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: cover,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    httpHeaders: const {
                      'user-agent': 'windows',
                    },
                  )
                : Image.asset(
                    'lib/assets/image/album_default.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
        ],
      ),
    );
  }
}
