import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/set_list_detail.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';

class LocalSetListCard extends StatelessWidget {
  final LocalSetListDetailModel playlist;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const LocalSetListCard({
    super.key,
    required this.playlist,
    required this.onTap,
    required this.onLongPress
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(YMusicRadius.md),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(YMusicRadius.md),
                child: Image.asset(
                  "/1.png",
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 180,
                      height: 180,
                      color: Colors.white10,
                      child: const Icon(Icons.music_note, color: Colors.white54, size: 46),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: YMusicSpacing.md),
          Text(
            playlist.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: YMusicTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}