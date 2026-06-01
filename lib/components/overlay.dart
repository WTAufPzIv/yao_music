import 'package:flutter/material.dart';
import 'package:yao_music/components/mini_player.dart';

import '../utils/nav_obs.dart';

class MiniPlayerOverlay {
  static OverlayEntry? _entry;

  static void refresh() {
    _entry?.markNeedsBuild();
  }

  static void show(BuildContext context) {
    if (_entry != null) return;
    _entry = OverlayEntry(
      builder: (context) {
        bool isHome = RouteManager.currentRoute == "/";
        bool isInPlayer = RouteManager.currentRoute == "/PlayerPage";
        return Positioned(
          left: 0,
          right: 0,
          bottom: isHome ? 70 : 0,
          child: Material(
            color: Colors.transparent,
            child: isInPlayer ? Container(
              height: 1,
            ) : Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: MiniPlayer()
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}