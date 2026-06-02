import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/set_list_detail.dart';
import '../../../providers/user/local_set_list_detail.dart';
import '../../../providers/user/local_tab.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';
import '../storage/user_local_Storage.dart';
import 'local_create_card.dart';
import 'local_set_list_card.dart';
import 'local_set_list_detail.dart';

class LocalTab extends StatefulWidget {
  const LocalTab({super.key});

  @override
  State<LocalTab> createState() => _LocalTabState();
}

class _LocalTabState extends State<LocalTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocalTabProvider>().loadLocalPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocalTabProvider>();
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
            child: LocalCreateCard(inertLocalPlayList: provider.inertLocalPlayList),
          ),
        ),
        if (provider.localLoading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CupertinoActivityIndicator()),
          )
        else if (provider.localPlaylists.isEmpty)
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
              delegate: SliverChildBuilderDelegate((context, index) {
                  return LocalSetListCard(
                    playlist: provider.localPlaylists[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: "/LocalSetListDetail"),
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => LocalSetListDetailProvider(),
                            child: LocalSetListDetail(
                                detail: provider.localPlaylists[index]
                            ),
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      provider.openDeleteSheet(index, context);
                    },
                  );
                },
                childCount: provider.localPlaylists.length,
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
}