import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:yao_music/models/personalized_set_list.dart';

import '../../../components/music_cover.dart';
import '../../../constants/load_state.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/set_list_provider.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';
import '../../set_list_detail/set_list_detail.dart';

class PersonalizedSetList extends StatefulWidget {
  const PersonalizedSetList({super.key});

  @override
  State<PersonalizedSetList> createState() =>_PersonalizedSetListState();
}

class _PersonalizedSetListState extends State<PersonalizedSetList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 确保 context 安全
    Future.microtask(() {
      context.read<HomeProvider>().loadPersonalizedSetListData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<HomeProvider>();
    bool loading = provider.loadPersonalizedState == LoadState.loading;
    final List<PersonalizedSetListModel> personalized = provider.personalized;

    final PageController controller = PageController(
      viewportFraction: 0.42,
    );

    return (
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: YMusicSpacing.xxxl),
            /// 标题
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: YMusicSpacing.lg,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(
                        name: "/PersonalizedSetListFull",
                      ),
                      builder: (_) => const PersonalizedSetListFull(),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '歌单已更新',
                      style: YMusicTextStyles.title1,
                    ),
                    SizedBox(width: YMusicSpacing.xxs),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white.withOpacity(0.6),
                      size: 30,
                    ),
                  ],
                )
              )
            ),
            const SizedBox(height: YMusicSpacing.md),
            Padding(
              padding: const EdgeInsets.only(
                left: YMusicSpacing.lg,
              ),
              child: Skeletonizer(
                enabled: loading,
                enableSwitchAnimation: true,
                child: SizedBox(
                  height: 374,
                  child: PageView.builder(
                    controller: controller,
                    padEnds: false,
                    itemCount: (personalized.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      final int offset =(personalized.length / 2).ceil();
                      final topItem = personalized[index];
                      final bool hasBottomItem = index + offset < personalized.length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 上半部分
                          _PersonalizedSetListCard(
                            personalized: topItem,
                            loading: loading,
                          ),
                          const SizedBox(height: 12),
                          /// 下半部分（可能不存在）
                          if (hasBottomItem)
                            _PersonalizedSetListCard(
                              personalized: personalized[index + offset],
                              loading: loading,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ),
          ],
        )
    );
  }
}

class PersonalizedSetListFull extends StatefulWidget {
  const PersonalizedSetListFull({super.key});

  @override
  State<PersonalizedSetListFull> createState() => _PersonalizedSetListFullState();
}

class _PersonalizedSetListFullState extends State<PersonalizedSetListFull> {
  @override
  void initState() {
    super.initState();
    // 确保 context 安全
    Future.microtask(() {
      context.read<HomeProvider>().loadPersonalizedSetListDataFull();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    bool loading = provider.loadPersonalizedStateFull == LoadState.loading;
    final List<PersonalizedSetListModel> personalizedFull = provider.personalizedFull;
    return (
      Scaffold(
        backgroundColor: YMusicColors.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              /// 是否固定顶部
              pinned: true,
              /// 展开高度
              expandedHeight: 0,
              /// 毛玻璃效果
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20,
                    sigmaY: 20,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.65),
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: YMusicColors.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: false,
              title: const Text(
                  '歌单已更新',
                  style: YMusicTextStyles.router
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
                        return Skeletonizer(
                          enabled: loading,
                          enableSwitchAnimation: true,
                          child: Center(
                              child: _PersonalizedSetListCard(
                                personalized: personalizedFull[index],
                                loading: loading,
                                isSimple: false,
                              )
                          )
                        );
                      },
                  childCount: loading ? 8 : 100,
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
        ),
      )
    );
  }
}

class _PersonalizedSetListCard extends StatelessWidget {
  final PersonalizedSetListModel personalized;
  final bool loading;
  final bool isSimple;
  const _PersonalizedSetListCard({
    required this.personalized,
    required this.loading,
    this.isSimple = true
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isSimple ? 150 : 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(
                      name: "/SetListDetail",
                    ),
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => SetListProvider(),
                      child: SetListDetail(setListId: personalized.id),
                    ),
                  ),
                );
              },
              child: /// 封面
              personalized.picUrl!.startsWith('http') ? MusicCover(
                imageUrl: '${personalized.picUrl}?param=300y300',
                width: isSimple ? 150 : 180,
                height: isSimple ? 150 : 180,
                radius: YMusicRadius.md,
              ): Image.asset(
                personalized.picUrl,
                width: isSimple ? 150 : 180,
                height: isSimple ? 150 : 180,
                fit: BoxFit.cover,
              ),
          ),
          const SizedBox(height: YMusicSpacing.md),
          /// 标题
          Padding(
            padding: EdgeInsets.only(
              right: isSimple ? YMusicSpacing.xl : 0
            ),
            child: Text(
                personalized.name,
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