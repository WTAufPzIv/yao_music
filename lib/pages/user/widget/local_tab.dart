import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/set_list_detail.dart';
import '../../../providers/user/local_set_list_detail.dart';
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
  bool _localLoading = true;
  List<LocalSetListDetailModel> _localPlaylists = [];

  @override
  void initState() {
    super.initState();
    _loadLocalPlaylists();
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

  Future<void> inertLocalPlayList(LocalSetListDetailModel item) async {
    setState(() {
      _localPlaylists.insert(0, item);
    });
    await _saveLocalPlaylists();
  }

  Future<void> removeFormLocalPlayList(int index) async {
    if (index < 0 || index >= _localPlaylists.length) {
      return;
    }
    setState(() {
      _localPlaylists.removeAt(index);
    });
    await _saveLocalPlaylists();
  }

  Future<void> openDeleteSheet (int index) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: YMusicColors.background,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 500,
            ),
            padding: EdgeInsetsGeometry.only(bottom: 35),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E).withOpacity(0.94),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 顶部拖拽条
                Padding(
                  padding: const EdgeInsets.only(
                    top: YMusicSpacing.md,
                  ),
                  child: Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: YMusicSpacing.md,
                    vertical: YMusicSpacing.md,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          Navigator.pop(sheetContext);
                          return removeFormLocalPlayList(index);
                        },
                        child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: YMusicSpacing.lg,
                                horizontal: YMusicSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                      CupertinoIcons.delete,
                                      color: YMusicColors.primary,
                                      size: 25
                                  ),
                                  SizedBox(
                                    width: YMusicSpacing.md,
                                  ),
                                  Text(
                                      '删除歌单',
                                      style: YMusicTextStyles.body,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: LocalCreateCard(inertLocalPlayList: inertLocalPlayList),
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
              delegate: SliverChildBuilderDelegate((context, index) {
                  return LocalSetListCard(
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
                    onLongPress: () {
                      openDeleteSheet(index);
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
}