import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../login/login_page.dart';

class GuestView extends StatelessWidget {
  final Future<void> Function() refreshAuthStatus;

  const GuestView(this.refreshAuthStatus, {super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> goLogin() async {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: "/LoginPage"),
          builder: (_) => const LoginPage(),
        ),
      );

      if (result == true) {
        await refreshAuthStatus();
        return;
      }
    }

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '尚未登录',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '登录后同步你的收藏、歌单和播放记录',
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffff375f),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              onPressed: goLogin,
              child: const Text(
                '去登录',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}