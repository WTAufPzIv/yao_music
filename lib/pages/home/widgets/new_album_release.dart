import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../constants/load_state.dart';
import '../../../models/new_album_release.dart';
import '../../../providers/home_provider.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';

class NewAlbumRelease extends StatefulWidget {
  const NewAlbumRelease({ super.key });

  @override
  State<NewAlbumRelease> createState() => _NewAlbumReleaseState();
}

class _NewAlbumReleaseState extends State<NewAlbumRelease> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 确保 context 安全
    Future.microtask(() {
      context.read<HomeProvider>().loadNewAlbumRelease();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<HomeProvider>();
    bool loading = provider.loadNewAlbumReleaseState == LoadState.loading;
    final List<NewAlbumReleaseModel> newAlbumRelease = provider.newAlbum;

    final PageController controller = PageController(
      viewportFraction: 0.42,
    );

    return (
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    '新碟上架',
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
                  height: 200,
                  child: PageView.builder(
                    controller: controller,
                    padEnds: false,
                    itemCount: newAlbumRelease.length,
                    itemBuilder: (context, index) {
                      return  _NewAlbumReleaseCard(
                        album: newAlbumRelease[index],
                        loading: loading,
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

class _NewAlbumReleaseCard extends StatelessWidget {
  final NewAlbumReleaseModel album;
  final bool loading;
  const _NewAlbumReleaseCard({
    required this.album,
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
            child: album.picUrl!.startsWith('http') ? Image.network(
              album.picUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ): Image.asset(
              album.picUrl,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    album.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: YMusicTextStyles.bodySmall
                ),
                SizedBox(height: YMusicSpacing.xs),
                Text(
                    album.artistNames,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: YMusicTextStyles.caption
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}