import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_radius.dart';

class MusicCover extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double radius;

  const MusicCover({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.radius
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius + 1),
        border: Border.all(
          color: Colors.white.withOpacity(0.16),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.08),
            blurRadius: YMusicRadius.md,
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          httpHeaders: {'user-agent': 'windows'},
          width: width,
          height: height,
          placeholder: (context, url) {
            return Container(
              color: Colors.white10,
            );
          },
          fadeInDuration: Duration.zero,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}