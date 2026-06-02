import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final bool isLoggedIn;
  final dynamic userInfo;
  String get avatarUrl {
    return (isLoggedIn && (userInfo?.avatarUrl ?? '').toString().isNotEmpty
        ? '${userInfo.avatarUrl}?param=800y800'
        : 'https://picsum.photos/seed/ymusic-user-avatar/800/800');
  }

  const UserAvatar(this.isLoggedIn, this.userInfo, { super.key });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: isLoggedIn
            ? CachedNetworkImage(
          imageUrl: avatarUrl,
          httpHeaders: {'user-agent': 'windows'},
          fit: BoxFit.cover,
        ) : Container(
          color: Colors.white10,
          child: const Icon(Icons.person, color: Colors.white, size: 56),
        ),
      ),
    );
  }
}