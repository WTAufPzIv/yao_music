import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/theme/app_color.dart';
import 'package:yao_music/theme/app_text.dart';

import '../../constants/load_state.dart';
import '../../pages/login/login_page.dart';
import '../../providers/login_provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({ super.key });

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshAuthStatus();
    });
  }

  Future<void> refreshAuthStatus() async {
    if (!mounted) return;
    await context.read<LoginProvider>().loadLoginStatus();
  }

  Future<void> _goLogin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );

    if (result == true) {
      await refreshAuthStatus();
      if (!mounted) return;
    }
  }

  Future<void> _logout() async {
    await context.read<LoginProvider>().loadLout();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已退出登录')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      backgroundColor: YMusicColors.background,
      body: Stack(
        children: [
          _buildBackground(loginProvider),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.18)),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  expandedHeight: 0,
                  actions: [
                    if (loginProvider.userinfo.isLogin)
                      IconButton(
                        onPressed: _logout,
                        icon: Icon(CupertinoIcons.arrow_right, color: Colors.white),
                      ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: loginProvider.loadState == LoadState.loading
                        ? _loadingCard()
                        : loginProvider.userinfo.isLogin
                        ? _loggedInView(loginProvider)
                        : _guestView(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(LoginProvider loginProvider) {
    final bg = loginProvider.userinfo.userinfo.backgroundUrl;
    if (bg != null && bg.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(bg),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff2a2a2a),
            Color(0xff121212),
            Color(0xff090909),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          vertical: 100
        ),
        child: Text(loginProvider.loadState.toString(), style: YMusicTextStyles.title1),
      ),
    );
  }

  Widget _loadingCard() {
    return Container(
      height: 240,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: const CircularProgressIndicator(color: Color(0xffff375f)),
    );
  }

  Widget _guestView() {
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
              onPressed: _goLogin,
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

  Widget _loggedInView(LoginProvider loginProvider) {
    final user = loginProvider.userinfo.userinfo!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Image.network(
                    user.avatarUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.nickname,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Apple Music 风格个人主页',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _menuItem(Icons.favorite_border, '喜欢的音乐'),
              _menuItem(Icons.queue_music, '我的歌单'),
              _menuItem(Icons.history, '最近播放'),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xffff375f)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _logout,
                  child: const Text('退出登录'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          const Spacer(),
          Icon(
            CupertinoIcons.chevron_right,
            color: Colors.white.withOpacity(0.45),
            size: 18,
          ),
        ],
      ),
    );
  }
}