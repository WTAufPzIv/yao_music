import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/theme/app_color.dart';
import 'package:yao_music/theme/app_space.dart';
import 'package:yao_music/theme/app_text.dart';

import '../../components/music_cover.dart';
import '../../constants/load_state.dart';
import '../../models/login.dart';
import '../../pages/login/login_page.dart';
import '../../providers/login_provider.dart';
import '../../providers/set_list_provider.dart';
import '../../theme/app_radius.dart';
import '../set_list_detail/set_list_detail.dart';

class UserPage extends StatefulWidget {
  const UserPage({ super.key });

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  final ScrollController _scrollController = ScrollController();
  /// 滚动距离
  double scrollOffset = 0;
  /// 顶部标题动画进度
  double get collapseProgress {
    if (scrollOffset <= 300) return 0;
    final progress = ((scrollOffset - 300) / 60).clamp(0.0, 1.0);
    return progress;
  }

  final PageController controller = PageController(
    viewportFraction: 0.9,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshAuthStatus();
    });
    /// 监听滚动
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      scrollOffset = _scrollController.offset;
    });
  }

  Future<void> refreshAuthStatus() async {
    if (!mounted) return;
    await context.read<LoginProvider>().loadLoginStatus();
  }

  Future<void> _goLogin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(),
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
    bool loading = loginProvider.loadState == LoadState.loading;
    return Scaffold(
      backgroundColor: YMusicColors.background,
      body: loading ? const Center(
        child: CupertinoActivityIndicator(),
      ) : loginProvider?.userinfo?.userinfo?.userId != null && (loginProvider.userinfo.userinfo.userId) > 0 ? AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: YMusicColors.background,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              expandedHeight: 350,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      /// 背景封面
                      CachedNetworkImage(
                        imageUrl: '${loginProvider.userinfo.userinfo.backgroundUrl}?param=400y400',
                        width: 350,
                        height: 350,
                        httpHeaders: { "user-agent": 'windows' },
                        fit: BoxFit.cover,
                      ),
                      /// 渐变遮罩
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              YMusicColors.background.withOpacity(0.05),
                              YMusicColors.background,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.35),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(16),
                                child: Image.network(
                                  '${loginProvider.userinfo.userinfo.avatarUrl ?? ''}?param=800y800',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: YMusicColors.background.withOpacity(collapseProgress),
                          child: Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).padding.top),
                              SizedBox(
                                height: kToolbarHeight,
                                child: Row(
                                  children: [
                                    const SizedBox(width: YMusicSpacing.md),
                                    Expanded(
                                      child: Opacity(
                                        opacity: collapseProgress,
                                        child: Transform.translate(
                                          offset: Offset(
                                            0,
                                            20 * (1 - collapseProgress),
                                          ),
                                          child: Text(
                                            '${loginProvider.userinfo.userinfo.nickname}的主页',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(onPressed: () {
                                      loginProvider.showLogoutSheet(context);
                                    }, icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ))
                                  ],
                                ),
                              ),
                            ],
                          )
                        ),
                      ),
                    ],
                  );
                }
              )
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: YMusicSpacing.md),
                  Text(
                    loginProvider.userinfo.userinfo.nickname ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: YMusicTextStyles.title3,
                  ),
                  SizedBox(height: YMusicSpacing.md),
                  Text(
                    loginProvider.userinfo.userinfo.signature ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: YMusicTextStyles.body.copyWith(color: YMusicTextStyles.title3.color?.withOpacity(0.5)),
                  ),
                  SizedBox(height: YMusicSpacing.md),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: YMusicSpacing.lg,
                  vertical: YMusicSpacing.md
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return _UserSetListCard(
                      setList: loginProvider.userinfo.setList[index],
                    );
                  },
                  childCount: loginProvider.userinfo.setList.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  /// 双列
                  crossAxisCount: 2,
                  /// 左右间距
                  crossAxisSpacing: YMusicSpacing.md,
                  /// 上下间距
                  mainAxisSpacing: YMusicSpacing.md,
                  /// 卡片宽高比例
                  childAspectRatio: 0.8,
                ),
              ),
            ),
          ],
        )
      ) : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: YMusicSpacing.xxl,
                vertical: 120
              ),
              child: _guestView(),
            )
          ],
        ),
      )
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
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => SetListProvider(),
                    child: SetListDetail(
                      setListId: setList.id,
                    ),
                  ),
                ),
              );
            },
            child: /// 封面
            setList.picUrl!.startsWith('http') ? MusicCover(
              imageUrl: '${setList.picUrl}?param=300y300',
              width: 180,
              height: 180,
              radius: YMusicRadius.md,
            ): Image.asset(
              setList.picUrl,
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: YMusicSpacing.md),
          /// 标题
          Padding(
            padding: EdgeInsets.only(
                right: 0
            ),
            child: Text(
                setList.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: YMusicTextStyles.bodySmall
            ),
          )
        ],
      ),
    );
  }
}