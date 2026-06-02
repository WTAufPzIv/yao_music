import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/pages/user/widget/guest_view.dart';
import 'package:yao_music/pages/user/widget/set_list_card.dart';

import '../../../constants/load_state.dart';
import '../../../providers/login_provider.dart';
import '../../../theme/app_space.dart';

class RemoteTab extends StatefulWidget {
  final Future<void> Function() refreshAuthStatus;
  const RemoteTab(this.refreshAuthStatus, {super.key});

  @override
  State<RemoteTab> createState() => _RemoteTabState();
}


class _RemoteTabState extends State<RemoteTab> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();
    final loadState = loginProvider.loadState;
    final remoteList = loginProvider.userinfo?.setList ?? [];
    final userInfo = loginProvider.userinfo?.userinfo;
    final isLoggedIn = (userInfo?.userId ?? 0) > 0;
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
              child: GuestView(widget.refreshAuthStatus),
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
                return SetListCard(
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
}