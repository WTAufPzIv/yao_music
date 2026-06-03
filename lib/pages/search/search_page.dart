import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/constants/load_state.dart';
import 'package:yao_music/providers/search_provider.dart';
import 'package:yao_music/theme/app_space.dart';
import 'package:yao_music/theme/app_text.dart';

import '../../models/search.dart';
import '../../models/set_list_detail.dart';
import '../../models/song_detail.dart';
import '../../providers/song_detail_provider.dart';
import '../../providers/user/local_tab.dart';
import '../../theme/app_color.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _textController = TextEditingController();

  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 距离底部 300px 时开始预加载下一页
    if (_controller.position.extentAfter < 300) {
      context.read<SearchProvider>().loadMore();
    }
  }

  void _onSearchSubmit(SearchProvider provider, String val) {
    if (val == null || val.isEmpty) return;
    _query = val;
    provider.changeKeyWords(_query);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    final playerProvider = context.read<SongDetailProvider>();
    final localTabProvider = context.read<LocalTabProvider>();
    final list = provider.list;
    final bool loading = provider.loading == LoadState.loading;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('搜索'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: CupertinoSearchTextField(
              controller: _textController,
              autofocus: false,
              style: const TextStyle(color: Colors.white),
              placeholder: '搜索单曲、歌手、专辑',
              placeholderStyle: const TextStyle(color: Color(0xFF8E8E93)),
              prefixIcon: const Icon(CupertinoIcons.search, color: Color(0xFF8E8E93), size: 18),
              suffixIcon: const Icon(CupertinoIcons.xmark_circle_fill, color: Color(0xFF8E8E93), size: 18),
              backgroundColor: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(14),
              onSubmitted: (String val) => _onSearchSubmit(provider, val),
            ),
          ),
          _buildSortBar(provider),
          const Divider(height: 1, color: Colors.white12),
          Expanded(
              child: _query.isEmpty ? _EmptyHint() : list.isEmpty && loading
                  ? const Center(child: CircularProgressIndicator())
                  : list.isEmpty
                    ? _NoResultView(query: _query)
                    :ListView.separated(
                      controller: _controller,
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                      itemCount: list.length + 1,
                      separatorBuilder: (_, __) => Divider(
                        color: Colors.white.withOpacity(0.10),
                        height: YMusicSpacing.xxl,
                      ),
                      itemBuilder: (context, index) {
                        if (index == list.length) {
                          return _buildBottomLoader(provider);
                        }
                        final item = list[index];
                        return GestureDetector(
                          onTap: () {
                            playerProvider.setPlayListAndPlay([
                              SingMiniInfo(
                                  id: item.id as dynamic,
                                  platform: provider.platform,
                                  name: item.name,
                                  artistName: item.artistNames,
                                  albumName: item.album,
                                  picId: item.picId
                              )
                            ], 0);
                          },
                          child: _buildResultItem(item, provider, localTabProvider),
                        );
                      },
                    )
          ),
        ],
      ),
    );
  }

  Widget _buildSortBar(SearchProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _sortChip(
              label: '网易云音乐',
              selected: provider.platform == SearchPlatform.netease,
              onTap: () => provider.changePlatForm(SearchPlatform.netease)
          ),
          const SizedBox(width: 12),
          _sortChip(
              label: 'joox',
              selected: provider.platform == SearchPlatform.joox,
              onTap: () => provider.changePlatForm(SearchPlatform.joox)
          ),
          const SizedBox(width: 12),
          _sortChip(
              label: 'Bilibili',
              selected: provider.platform == SearchPlatform.bilibili,
              onTap: () => provider.changePlatForm(SearchPlatform.bilibili)
          )
        ],
      ),
    );
  }

  Widget _sortChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white12,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(SearchResultItem result, SearchProvider searchProvider, LocalTabProvider localTabProvider) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: YMusicSpacing.md
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.name,
                  style: YMusicTextStyles.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: YMusicSpacing.xs,
                ),
                Text(
                  result.artistNames,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: YMusicTextStyles.bodySmall,
                )
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: YMusicColors.primary,
            ),
            onPressed: () {
              print(result.picId);
              localTabProvider.addSongToLocalPlayList(LocalSetListDetailSongsModel(
                id: result.id,
                name: result.name,
                picId: result.picId,
                platform: searchProvider.platform,
                artistList: [
                  ArtistOfSetListSong(
                    id: -1,
                    name: result.artistNames
                  )
                ],
                album: AlbumOfSetListSong(
                  id: -1,
                  name: '',
                  picUrl: ''
                ),
              ), context);
            },
          )
        ],
      )
    );
  }

  Widget _buildBottomLoader(SearchProvider provider) {
    if (provider.list.isEmpty) return const SizedBox.shrink();

    if (provider.more) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          '没有更多了',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}

class _NoResultView extends StatelessWidget {
  final String query;

  const _NoResultView({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.search_off, color: Color(0xFF8E8E93), size: 34),
            ),
            const SizedBox(height: 18),
            Text(
              '没有找到“$query”',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '换个关键词试试，或者切换到其他平台。',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: YMusicSpacing.xxxl,
        ),
        const Text(
          '开始搜索',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '搜索单曲、歌手或专辑',
          style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 22)
      ],
    );
  }
}

