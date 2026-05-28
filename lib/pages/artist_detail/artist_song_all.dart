import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/constants/load_state.dart';

import '../../models/artist_detail.dart';
import '../../providers/artist_detail_provider.dart';

class ArtistSongAll extends StatefulWidget {
  final int artistId;
  final String artistName;

  const ArtistSongAll({super.key,  required this.artistId, required this.artistName });

  @override
  State<ArtistSongAll> createState() => _ArtistSongAllState();
}

class _ArtistSongAllState extends State<ArtistSongAll> {
  final ScrollController _controller = ScrollController();

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
      context.read<ArtistAllSongProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final artistDetailProvider = context.read<ArtistDetailProvider>();
    final provider = context.watch<ArtistAllSongProvider>();
    final list = provider.list;
    final bool loading = provider.loading == LoadState.loading;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${widget.artistName}的歌曲'),
      ),
      body: Column(
        children: [
          _buildSortBar(provider),
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: list.isEmpty && loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _controller,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length + 1,
              itemBuilder: (context, index) {
                if (index == list.length) {
                  return _buildBottomLoader(provider);
                }
                final song = list[index];
                return _buildSongItem(song, artistDetailProvider);
              },
            )
          ),
        ],
      ),
    );
  }

  Widget _buildSortBar(ArtistAllSongProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _sortChip(
            label: '时间',
            selected: provider.order == ArtistAllSongOrderType.time,
            onTap: () => provider.changeOrder(ArtistAllSongOrderType.time)
          ),
          const SizedBox(width: 12),
          _sortChip(
            label: '热度',
            selected: provider.order == ArtistAllSongOrderType.hot,
            onTap: () => provider.changeOrder(ArtistAllSongOrderType.hot)
          ),
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

  Widget _buildSongItem(SongsOfArtistDetail song, ArtistDetailProvider provider) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          '${song.album.picUrl}?param=100y100',
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        song.name,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artistNames,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white54, fontSize: 13),
      ),
      trailing: IconButton(onPressed: () {
        provider.showSongInfoSheet(context, song);
      }, icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ))
      // onTap: () {
      //   // 播放 / 进入详情
      // },
    );
  }

  Widget _buildBottomLoader(ArtistAllSongProvider provider) {
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

