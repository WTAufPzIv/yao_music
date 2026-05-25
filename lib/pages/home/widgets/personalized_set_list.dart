import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:yao_music/models/personalized_set_list.dart';

import '../../../constants/load_state.dart';
import '../../../providers/home_provider.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';

class PersonalizedSetList extends StatefulWidget {
  const PersonalizedSetList({super.key});

  @override
  State<PersonalizedSetList> createState() =>_PersonalizedSetListState();
}

class _PersonalizedSetListState extends State<PersonalizedSetList> {
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
            ),
            const SizedBox(height: YMusicSpacing.md),
            Padding(
              padding: const EdgeInsets.only(
                left: YMusicSpacing.lg,
              ),
              child: Skeletonizer(
                enabled: loading,
                child: SizedBox(
                  height: 370,
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

class _PersonalizedSetListCard extends StatelessWidget {
  final PersonalizedSetListModel personalized;
  final bool loading;
  const _PersonalizedSetListCard({
    required this.personalized,
    required this.loading
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 封面
          ClipRRect(
            borderRadius: BorderRadius.circular(YMusicRadius.md),
            child: personalized.picUrl!.startsWith('http') ? Image.network(
              personalized.picUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ): Image.asset(
              personalized.picUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: YMusicSpacing.md),
          /// 标题
          Padding(
            padding: EdgeInsets.only(
              right: YMusicSpacing.xl
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