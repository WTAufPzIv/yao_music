import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:yao_music/theme/app_color.dart';

import '../../api/mv_all_api.dart';

class MVPlayerPage extends StatefulWidget {
  final int id;
  final String name;
  final String cover;
  final String artistName;
  final String desc;

  const MVPlayerPage({
    super.key,
    required this.id,
    required this.name,
    required this.cover,
    required this.artistName,
    required this.desc,
  });

  @override
  State<MVPlayerPage> createState() => _MVPlayerPageState();
}

class _MVPlayerPageState extends State<MVPlayerPage> {
  VideoPlayerController? _controller;

  bool loading = true;
  bool initialized = false;
  bool hasError = false;

  Timer? _hideTimer;
  Timer? _gestureTimer;

  Duration _seekTargetPosition = Duration.zero;
  String url = '';
  Future<void>? _initFuture;

  bool _isFullScreen = false;
  bool _showControls = true;

  bool _isDragging = false;
  bool _isHorizontalDrag = false;
  double _dragDeltaX = 0;
  double _dragDeltaY = 0;

  Duration _dragStartPosition = Duration.zero;
  double _dragStartVolume = 1.0;

  double _stageWidth = 1;
  double _stageHeight = 1;

  bool _showGestureTip = false;
  String _gestureTip = '';

  @override
  void initState() {
    super.initState();
    fetchUrl();
    /*WakelockPlus.enable();*/
  }

  Future<void> fetchUrl() async {
    try {
      setState(() {
        loading = true;
      });
      final urll = await MvAllApi.fetchMvUrl(widget.id);
      url = (urll != null && urll.isNotEmpty) ?  urll.replaceAll('http', 'https') : '';
      await _initPlayer();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _initPlayer() async {
    if (url == null || url.isEmpty) {
      setState(() {
        initialized = true;
        hasError = true;
      });
      return;
    }
    try {
      _controller?.dispose();

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );

      await _controller!.initialize();

      setState(() {
        initialized = true;
        hasError = false;
      });

      if (!mounted) return;

      _controller!.addListener(() {
        if (!mounted) return;

        if (_controller!.value.hasError) {
          debugPrint(
            "Video Error: ${_controller!.value.errorDescription}",
          );
        }

        setState(() {});
      });

      setState(() {
        initialized = true;
        hasError = false;
      });
    } catch (e, s) {
      debugPrint("MV init error: $e");
      debugPrint("$s");

      if (!mounted) return;

      setState(() {
        hasError = true;
        initialized = false;
      });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _gestureTimer?.cancel();

    _controller?.dispose();

    _restoreSystemUI();

    super.dispose();
  }

  Future<void> _restoreSystemUI() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> _enterFullScreen() async {
    setState(() => _isFullScreen = true);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _scheduleHideControls();
  }

  Future<void> _exitFullScreen() async {
    setState(() => _isFullScreen = false);
    _hideTimer?.cancel();
    setState(() => _showControls = true);
    await _restoreSystemUI();
  }

  Future<void> _toggleFullScreen() async {
    if (_isFullScreen) {
      await _exitFullScreen();
    } else {
      await _enterFullScreen();
    }
  }

  void _togglePlay() {
    if (!_controller!.value.isInitialized) return;

    if (_controller!.value.isPlaying) {
      _controller!.pause();
      _hideTimer?.cancel();
      setState(() => _showControls = true);
    } else {
      _controller!.play();
      setState(() => _showControls = true);
      if (_isFullScreen) _scheduleHideControls();
    }
  }

  void _scheduleHideControls() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (_controller!.value.isPlaying && _isFullScreen) {
        setState(() => _showControls = false);
      }
    });
  }

  void _showControlsTemporarily() {
    setState(() => _showControls = true);
    if (_controller!.value.isPlaying && _isFullScreen) {
      _scheduleHideControls();
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (!_controller!.value.isInitialized) return;

    _isDragging = true;
    _isHorizontalDrag = false;
    _dragDeltaX = 0;
    _dragDeltaY = 0;
    _dragStartPosition = _controller!.value.position;
    _dragStartVolume = _controller!.value.volume;

    _showControlsTemporarily();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_controller!.value.isInitialized) return;

    _dragDeltaX += details.delta.dx;
    _dragDeltaY += details.delta.dy;

    if (!_isHorizontalDrag) {
      final absX = _dragDeltaX.abs();
      final absY = _dragDeltaY.abs();

      if (absX < 6 && absY < 6) return;
      _isHorizontalDrag = absX >= absY;
    }

    if (_isHorizontalDrag) {
      final duration = _controller!.value.duration;
      if (duration.inMilliseconds <= 0) return;

      final deltaMs = (_dragDeltaX / _stageWidth) * duration.inMilliseconds;
      final targetMs = _dragStartPosition.inMilliseconds + deltaMs.round();

      final clampedMs = targetMs.clamp(0, duration.inMilliseconds);
      final target = Duration(milliseconds: clampedMs);

      _seekTargetPosition = target;

      setState(() {
        _gestureTip = '${deltaMs >= 0 ? '快进' : '快退'} ${_formatDuration(Duration(milliseconds: deltaMs.abs().round()))}';
        _showGestureTip = true;
      });
    } else {
      final delta = -_dragDeltaY / _stageHeight;
      final targetVolume = (_dragStartVolume + delta).clamp(0.0, 1.0);

      _controller!.setVolume(targetVolume);

      setState(() {
        _gestureTip = '音量 ${(targetVolume * 100).round()}%';
        _showGestureTip = true;
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_controller != null) {
      _controller!.seekTo(_seekTargetPosition);
    }
    _isDragging = false;
    _isHorizontalDrag = false;

    _gestureTimer?.cancel();

    _gestureTimer = Timer(
      const Duration(milliseconds: 500),
          () {
        if (!mounted) return;

        setState(() {
          _showGestureTip = false;
        });
      },
    );

    if (_controller!.value.isPlaying && _isFullScreen) {
      _scheduleHideControls();
    }
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildCover(String url, {double size = 56}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: size,
            height: size,
            color: Colors.white12,
            alignment: Alignment.center,
            child: const Icon(Icons.music_note, color: Colors.white54),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                if (_isFullScreen) {
                  await _exitFullScreen();
                } else {
                  if (context.mounted) Navigator.pop(context);
                }
              },
              icon: Icon(
                _isFullScreen ? Icons.close : Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            const Expanded(
              child: Text(
                'MV播放',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStage({required bool fullScreen}) {
    final controller = _controller;
    if (controller == null) {
      return const SizedBox();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        _stageWidth = constraints.maxWidth <= 0 ? 1 : constraints.maxWidth;
        _stageHeight = constraints.maxHeight <= 0 ? 1 : constraints.maxHeight;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _togglePlay,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: Colors.black),
              if (_controller!.value.isInitialized)
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                )
              else
                Center(
                  child: Image.network(
                    widget.cover,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 120,
                        height: 120,
                        color: Colors.white12,
                        alignment: Alignment.center,
                        child: const Icon(Icons.play_circle_fill, size: 64, color: Colors.white54),
                      );
                    },
                  ),
                ),
              if (_showGestureTip)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _gestureTip,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              if (!_controller!.value.isPlaying)
                Center(
                  child: GestureDetector(
                    onTap: _togglePlay,
                    child: Container(
                      width: fullScreen ? 76 : 72,
                      height: fullScreen ? 76 : 72,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ),
                ),
              if (fullScreen && _showControls) _buildFullscreenOverlay(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFullscreenOverlay() {
    final controller = _controller;
    if (controller == null) {
      return const SizedBox();
    }
    final duration = controller.value.duration;
    final position = controller.value.position;
    final totalMs = duration.inMilliseconds <= 0 ? 1 : duration.inMilliseconds;
    final currentMs = position.inMilliseconds.clamp(0, totalMs);

    return IgnorePointer(
      ignoring: false,
      child: Container(
        color: Colors.black26,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFullScreen,
                      icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Text(
                      _formatDuration(Duration(milliseconds: currentMs)),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                        ),
                        child: Slider(
                          value: currentMs.toDouble(),
                          min: 0,
                          max: totalMs.toDouble(),
                          onChanged: (value) {
                            _controller!.seekTo(Duration(milliseconds: value.round()));
                            _showControlsTemporarily();
                          },
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(duration),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _togglePlay,
                      iconSize: 34,
                      icon: Icon(
                        _controller!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitControls() {
    final controller = _controller;
    if (controller == null) {
      return const SizedBox();
    }
    final duration = controller.value.duration;
    final position = controller.value.position;
    final totalMs = duration.inMilliseconds <= 0 ? 1 : duration.inMilliseconds;
    final currentMs = position.inMilliseconds.clamp(0, totalMs);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                _formatDuration(Duration(milliseconds: currentMs)),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                  ),
                  child: Slider(
                    activeColor: YMusicColors.primary,
                    value: currentMs.toDouble(),
                    min: 0,
                    max: totalMs.toDouble(),
                    onChanged: (value) {
                      _controller!.seekTo(Duration(milliseconds: value.round()));
                    },
                  ),
                ),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: _togglePlay,
                iconSize: 34,
                icon: Icon(
                  _controller!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _controller!.value.isInitialized
                      ? (_controller!.value.isPlaying ? '播放中' : '已暂停')
                      : '正在加载视频…',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
              IconButton(
                onPressed: _toggleFullScreen,
                icon: const Icon(Icons.fullscreen, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCover(widget.cover, size: 72),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.artistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitPage() {
    return Column(
      children: [
        _buildTopBar(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildStage(fullScreen: false),
            ),
          ),
        ),
        _buildInfoCard(),
        _buildPortraitControls(),
      ],
    );
  }

  Widget _buildFullScreenPage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildStage(fullScreen: true),
        if (!_showControls && _controller!.value.isPlaying)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context),
          ),
      ],
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white54,
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              "MV加载失败",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: fetchUrl,
              child: const Text("重试"),
            )
          ],
        ),
      );
    }

    if (!initialized || _controller == null) {
      return const SizedBox();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _isFullScreen
          ? _buildFullScreenPage()
          : SafeArea(
        child: _buildPortraitPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isFullScreen) {
          await _exitFullScreen();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: loading ? const Center(
          child: CupertinoActivityIndicator(),
        ) : _buildBody(),
      ),
    );
  }
}
