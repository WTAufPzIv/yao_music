import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/load_state.dart';
import '../../models/login.dart';
import '../../models/set_list_detail.dart';
import '../../pages/login/login_page.dart';
import '../../providers/local_set_list_detail.dart';
import '../../providers/login_provider.dart';
import '../../providers/set_list_provider.dart';
import '../../theme/app_color.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_space.dart';
import '../../theme/app_text.dart';
import '../set_list_detail/set_list_detail.dart';
import 'local_play_list.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  final TextEditingController _playlistNameController = TextEditingController();

  bool _localLoading = true;
  List<LocalSetListDetailModel> _localPlaylists = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshAuthStatus();
    });

    _loadLocalPlaylists();
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    super.dispose();
  }

  Future<void> refreshAuthStatus() async {
    if (!mounted) return;
    await context.read<LoginProvider>().loadLoginStatus();
  }

  Future<void> _loadLocalPlaylists() async {
    final list = await LocalPlaylistStorage.load();
    if (!mounted) return;
    setState(() {
      _localPlaylists = list;
      _localLoading = false;
    });
  }

  Future<void> _saveLocalPlaylists() async {
    await LocalPlaylistStorage.save(_localPlaylists);
  }

  Future<void> _createLocalPlaylist() async {
    _playlistNameController.clear();

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xff1c1c1e),
          title: const Text(
            '创建本地歌单',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _playlistNameController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '请输入歌单名称',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xffff375f)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                '取消',
                style: TextStyle(color: Colors.white.withOpacity(0.75)),
              ),
            ),
            TextButton(
              onPressed: () {
                final value = _playlistNameController.text.trim();
                if (value.isEmpty) return;
                Navigator.pop(dialogContext, value);
              },
              child: const Text(
                '创建',
                style: TextStyle(color: Color(0xffff375f)),
              ),
            ),
          ],
        );
      },
    );

    if (name == null || name.trim().isEmpty) return;

    final randomId = DateTime.now().millisecondsSinceEpoch + Random().nextInt(99999);
    final coverUrl = 'https://picsum.photos/seed/$randomId/500/500';

    final playlist = LocalSetListDetailModel(
      id: randomId,
      name: name.trim(),
      songs: []
    );

    setState(() {
      _localPlaylists.insert(0, playlist);
    });
    await _saveLocalPlaylists();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已创建本地歌单：${playlist.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _goLogin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: "/LoginPage"),
        builder: (_) => const LoginPage(),
      ),
    );

    if (result == true) {
      await refreshAuthStatus();
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();
    final userInfo = loginProvider.userinfo?.userinfo;
    final isLoggedIn = (userInfo?.userId ?? 0) > 0;

    return Scaffold(
      backgroundColor: YMusicColors.background,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
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
                    indicatorColor: Color(0xffff375f),
                    tabs: [
                      Tab(text: '网易云歌单'),
                      Tab(text: '本地歌单'),
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
                              _buildAvatar(isLoggedIn, userInfo),
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
                  return _buildRemoteTab(context, loginProvider, isLoggedIn);
                },
              ),
              Builder(
                builder: (context) {
                  return _buildLocalTab(context);
                },
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget _buildHeaderBackground(bool isLoggedIn, dynamic userInfo) {
    final bgUrl = isLoggedIn && (userInfo?.backgroundUrl ?? '').toString().isNotEmpty
        ? '${userInfo.backgroundUrl}?param=1200y1200'
        : 'https://picsum.photos/seed/ymusic-user-header/1200/1200';

    return CachedNetworkImage(
      imageUrl: bgUrl,
      fit: BoxFit.cover,
      httpHeaders: {'user-agent': 'windows'},
    );
  }

  Widget _buildAvatar(bool isLoggedIn, dynamic userInfo) {
    final avatarUrl = isLoggedIn && (userInfo?.avatarUrl ?? '').toString().isNotEmpty
        ? '${userInfo.avatarUrl}?param=800y800'
        : 'https://picsum.photos/seed/ymusic-user-avatar/800/800';

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

  Widget _buildRemoteTab(
      BuildContext context,
      LoginProvider loginProvider,
      bool isLoggedIn,
      ) {
    final loadState = loginProvider.loadState;
    final userInfo = loginProvider.userinfo?.userinfo;
    final remoteList = loginProvider.userinfo?.setList ?? [];

    if (loadState == LoadState.loading) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    if (!isLoggedIn) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                YMusicSpacing.xxl,
                40,
                YMusicSpacing.xxl,
                80,
              ),
              child: _guestView(),
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            YMusicSpacing.md,
            YMusicSpacing.md,
            YMusicSpacing.md,
            70,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return _UserSetListCard(
                  setList: remoteList[index],
                );
              },
              childCount: remoteList.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: YMusicSpacing.md,
              mainAxisSpacing: YMusicSpacing.md,
              childAspectRatio: 0.8,
            ),
          ),
        ),
        if (remoteList.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                '这里还没有歌单',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocalTab(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              YMusicSpacing.md,
              YMusicSpacing.lg,
              YMusicSpacing.md,
              YMusicSpacing.md,
            ),
            child: _localCreateCard(),
          ),
        ),
        if (_localLoading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CupertinoActivityIndicator()),
          )
        else if (_localPlaylists.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  '还没有本地歌单，先创建一个吧',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              YMusicSpacing.md,
              YMusicSpacing.sm,
              YMusicSpacing.md,
              70,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _LocalPlaylistCard(
                    playlist: _localPlaylists[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: "/LocalSetListDetail"),
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => LocalSetListDetailProvider(),
                            child: LocalSetListDetail(
                                detail: _localPlaylists[index]
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: _localPlaylists.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: YMusicSpacing.md,
                mainAxisSpacing: YMusicSpacing.md,
                childAspectRatio: 0.8,
              ),
            ),
          ),
      ],
    );
  }

  Widget _localCreateCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xffff375f).withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.add,
              color: Color(0xffff375f),
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '创建本地歌单',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '输入名称后自动生成 id 和封面',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 42,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffff375f),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: _createLocalPlaylist,
              child: const Text('新建'),
            ),
          ),
        ],
      ),
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
}

class _UserSetListCard extends StatelessWidget {
  final UserSetListModel setList;
  const _UserSetListCard({
    required this.setList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/SetListDetail"),
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => SetListProvider(),
                    child: SetListDetail(
                      setListId: setList.id,
                    ),
                  ),
                ),
              );
            },
            child: _buildCover(),
          ),
          const SizedBox(height: YMusicSpacing.md),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Text(
              setList.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: YMusicTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    final pic = setList.picUrl ?? '';
    if (pic.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(YMusicRadius.md),
        child: CachedNetworkImage(
          imageUrl: '$pic?param=300y300',
          httpHeaders: {'user-agent': 'windows'},
          width: 180,
          height: 180,
          fit: BoxFit.cover
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(YMusicRadius.md),
      child: Image.asset(
        pic,
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
    );
  }
}

class _LocalPlaylistCard extends StatelessWidget {
  final LocalSetListDetailModel playlist;
  final VoidCallback onTap;

  const _LocalPlaylistCard({
    required this.playlist,
    required this.onTap,
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

class LocalPlaylistStorage {
  static const String _storageKey = 'ymusic_local_playlists';

  static Future<List<LocalSetListDetailModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => LocalSetListDetailModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<LocalSetListDetailModel> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(playlists.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }
}