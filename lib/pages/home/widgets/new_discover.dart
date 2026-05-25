import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:provider/provider.dart';

import '../../../constants/load_state.dart';
import '../../../models/new_discover.dart';
import '../../../providers/home_provider.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';

class NewDiscover extends StatefulWidget {
  const NewDiscover({super.key});

  @override
  State<NewDiscover> createState() => _DiscoverBannerState();
}

class _DiscoverBannerState extends State<NewDiscover> {
  final PageController controller = PageController(
    viewportFraction: 0.88,
  );

  @override
  void initState() {
    super.initState();
    // 确保 context 安全
    Future.microtask(() {
      context.read<HomeProvider>().loadBannerData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    bool loading = provider.loadBannerState == LoadState.loading;
    final List<NewDiscoverModel> banners = provider.banners;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 标题
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: YMusicSpacing.lg,
          ),
          child: Text(
            '新歌速递',
            style: YMusicTextStyles.title1,
          ),
        ),
        const SizedBox(height: YMusicSpacing.md),
        Padding(
          padding: const EdgeInsets.only(
            left: YMusicSpacing.lg,
          ),
          child: Skeletonizer(
            enabled: loading,
            child: SizedBox(
              height: 260,
              child: PageView.builder(
                padEnds: false,
                controller: controller,
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.only(
                        right: YMusicSpacing.md,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(YMusicRadius.xl),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // 背景图
                            banners[index]!.image.startsWith('http') ? Image.network(banners[index]!.image, fit: BoxFit.cover) : Image.asset(banners[index]!.image, fit: BoxFit.cover),
                            // 渐变遮罩
                            Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Color(0xCC000000),
                                      ]
                                  )
                              ),
                            ),
                            // 文字
                            Positioned(
                              left: YMusicSpacing.lg,
                              right: YMusicSpacing.lg,
                              bottom: YMusicSpacing.xl,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(banners[index]!.album, style: YMusicTextStyles.caption.copyWith(color: Colors.white70,)),
                                  const SizedBox(height: YMusicSpacing.xs),
                                  Text(banners[index]!.name, style: YMusicTextStyles.title1),
                                  const SizedBox(height: YMusicSpacing.xs),
                                  Text(banners[index]!.artistNames, style: YMusicTextStyles.title2),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}