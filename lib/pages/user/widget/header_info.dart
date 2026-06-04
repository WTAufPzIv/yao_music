import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/login_provider.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_text.dart';
import './remote_tab.dart';
import 'local_tab.dart';
import 'user_avatar.dart';

class HeaderInfo extends StatefulWidget {
  const HeaderInfo({super.key});

  @override
  State<HeaderInfo> createState() => _HeaderInfoState();
}

class _HeaderInfoState extends State<HeaderInfo> {
  Future<void> refreshAuthStatus() async {
    if (!mounted) return;
    await context.read<LoginProvider>().loadLoginStatus();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();
    final userInfo = loginProvider.userinfo?.userinfo;
    final isLoggedIn = (userInfo?.userId ?? 0) > 0;
    return (
        NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    backgroundColor: YMusicColors.background,
                    automaticallyImplyLeading: false,
                    expandedHeight: 400,
                    title: Text(
                      '我的主页',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: YMusicTextStyles.router,
                    ),
                    actions: [
                      if (isLoggedIn)
                        IconButton(
                          onPressed: () {
                            loginProvider.showLogoutSheet(context);
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                    ],
                    bottom: const TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      indicatorColor: YMusicColors.primary,
                      tabs: [
                        Tab(text: '本地歌单'),
                        Tab(text: '网易云歌单'),
                      ],
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildHeaderBackground(isLoggedIn, userInfo),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  YMusicColors.background.withOpacity(0.25),
                                  YMusicColors.background,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            right: 20,
                            bottom: 70,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                UserAvatar(isLoggedIn, userInfo),
                                const SizedBox(height: 16),
                                Text(
                                  isLoggedIn ? (userInfo?.nickname ?? '') : '尚未登录',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isLoggedIn
                                      ? (userInfo?.signature ?? '这个人很懒，什么都没写')
                                      : '登录后可同步你的收藏、歌单和播放记录',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
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
                ),
              ];
            },
            body: TabBarView(
              children: [
                Builder(
                  builder: (context) {
                    return LocalTab();
                  },
                ),
                Builder(
                  builder: (context) {
                    return RemoteTab(refreshAuthStatus);
                  },
                )
              ],
            )
        )
    );
  }

  Widget _buildHeaderBackground(bool isLoggedIn, dynamic userInfo) {
    final bgUrl = isLoggedIn && (userInfo?.backgroundUrl ?? '').toString().isNotEmpty
        ? '${userInfo.backgroundUrl}?param=800y800'
        : 'https://picsum.photos/seed/ymusic-user-header/800/800';

    return CachedNetworkImage(
      imageUrl: bgUrl,
      fit: BoxFit.cover,
      httpHeaders: {'user-agent': 'windows'},
    );
  }
}