import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/models/hot_top.dart';
import 'package:yao_music/models/personalized_set_list.dart';
import 'package:yao_music/models/rank_list.dart';
import 'package:yao_music/models/base/song_base.dart';
import 'package:yao_music/pages/artist_detail/artist_detail.dart';

import '../constants/load_state.dart';
import '../models/daily_recommend.dart';
import '../models/new_album_release.dart';
import '../models/new_discover.dart';
import '../pages/album_detail/album_detail.dart';
import '../services/home_service.dart';
import '../theme/app_color.dart';
import '../theme/app_space.dart';
import '../theme/app_text.dart';
import '../utils/index.dart';
import 'album_detail_provider.dart';
import 'artist_detail_provider.dart';

final random = Random();

class HomeProvider extends ChangeNotifier {
  /// Banner 数据
  List<NewDiscoverModel> banners = [];
  /// Banner状态
  LoadState loadBannerState = LoadState.loading;
  /// 日推数据
  List<DailyRecommendModel> daily = [];
  /// 日推加载状态
  LoadState loadDailyState = LoadState.loading;
  /// 推荐歌单数据
  List<PersonalizedSetListModel> personalized = [];
  /// 推荐歌单加载状态
  LoadState loadPersonalizedState = LoadState.loading;
  /// 推荐歌单数据 -100
  List<PersonalizedSetListModel> personalizedFull = [];
  /// 推荐歌单加载状态 - 100
  LoadState loadPersonalizedStateFull = LoadState.loading;
  /// 新碟上架数据
  List<NewAlbumReleaseModel> newAlbum = [];
  /// 新碟上架加载状态
  LoadState loadNewAlbumReleaseState = LoadState.loading;
  /// 新碟上架数据 - full
  List<NewAlbumReleaseModel> newAlbumFull = [];
  /// 新碟上架加载状态 - full
  LoadState loadNewAlbumReleaseStateFull = LoadState.loading;
  /// 热歌榜数据
  List<HotTopModel> hot = [];
  /// 热歌榜加载状态
  LoadState loadHotTopState = LoadState.loading;
  /// 榜单数据
  List<RankListModel> rank = [];
  /// 榜单数据加载状态
  LoadState loadRankListState = LoadState.loading;

  /// 加载banner数据
  Future<void> loadBannerData() async {
    banners = [NewDiscoverModel(
        id: 1999,
        name: '这是一条长的缺省文字',
        album: '这是一张专辑',
        artists: [ArtistModel(id: 1, name: 'AURORA')],
        image: 'lib/assets/image/banner.jpg'
    )];
    try {
      loadBannerState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getDiscoverBanner();
      banners = result;
      if (banners.isEmpty) {
        loadBannerState = LoadState.empty;
      } else {
        loadBannerState = LoadState.success;
      }
    } catch (e) {

      loadBannerState = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载日推数据
  Future<void> loadDailyData() async {
    List<DailyRecommendModel> place = List.generate(
      4,
      (_) => DailyRecommendModel(
          id: random.nextInt(100),
          name: '这是歌曲名称一首歌',
          album: AlbumOfDailyRecommend( id: random.nextInt(100), name: '这是专辑名称', picUrl: 'lib/assets/image/banner.jpg' ),
          artistList: [ ArtistOfDailyRecommend( id: random.nextInt(100), name: '这是歌手名称' ) ]
        ),
    );
    daily = place;
    try {
      loadDailyState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getDailyRecommend();
      daily = result;
      nextFrame(() {
        loadDailyState = LoadState.success;
      });
    } catch (e) {
      loadDailyState = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载推荐歌单
  Future<void> loadPersonalizedSetListData() async {
    List<PersonalizedSetListModel> place = List.generate(
      6,
          (_) => PersonalizedSetListModel(
          id: random.nextInt(100),
          name: '这是歌单名称',
          picUrl: 'lib/assets/image/banner.jpg'
      ),
    );
    personalized = place;
    try {
      loadPersonalizedState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getPersonalizedSetList();
      personalized = result;
      loadPersonalizedState = LoadState.success;
    } catch (e) {
      loadPersonalizedState = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载推荐歌单 - 100
  Future<void> loadPersonalizedSetListDataFull() async {
    List<PersonalizedSetListModel> place = List.generate(
      8,
          (_) => PersonalizedSetListModel(
          id: random.nextInt(100),
          name: '这是歌单名称',
          picUrl: 'lib/assets/image/banner.jpg'
      ),
    );
    personalizedFull = place;
    try {
      loadPersonalizedStateFull = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getPersonalizedSetListFull();
      personalizedFull = result;
      loadPersonalizedStateFull = LoadState.success;
    } catch (e) {
      loadPersonalizedStateFull = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载新碟上架
  Future<void> loadNewAlbumRelease() async {
    List<NewAlbumReleaseModel> place = List.generate(
      6,
          (_) => NewAlbumReleaseModel(
          id: random.nextInt(100),
          name: '这是专辑名称',
          picUrl: 'lib/assets/image/banner.jpg',
          artistList: [ ArtistOfNewAlbumReleaseModel(id: random.nextInt(100), name: '歌手名') ]
      ),
    );
    newAlbum = place;
    try {
      loadNewAlbumReleaseState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getNewAlbumRelease();
      newAlbum = result;
      loadNewAlbumReleaseState = LoadState.success;
    } catch (e) {
      loadNewAlbumReleaseState = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载新碟上架 - full
  Future<void> loadNewAlbumReleaseFull() async {
    List<NewAlbumReleaseModel> place = List.generate(
      6,
          (_) => NewAlbumReleaseModel(
          id: random.nextInt(100),
          name: '这是专辑名称',
          picUrl: 'lib/assets/image/banner.jpg',
          artistList: [ ArtistOfNewAlbumReleaseModel(id: random.nextInt(100), name: '歌手名') ]
      ),
    );
    newAlbumFull = place;
    try {
      loadNewAlbumReleaseStateFull = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getNewAlbumRelease();
      newAlbumFull = result;
      loadNewAlbumReleaseStateFull = LoadState.success;
    } catch (e) {
      loadNewAlbumReleaseStateFull = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载热歌榜
  Future<void> loadHotTop() async {
    List<HotTopModel> place = List.generate(
      10,
          (_) => HotTopModel(
          id: random.nextInt(100),
          name: '这是专辑名称',
          album: AlbumOfHotTop( id: random.nextInt(100), name: '这是专辑名称', picUrl: 'lib/assets/image/banner.jpg' ),
          artistList: [ ArtistOfHotTop(id: random.nextInt(100), name: '歌手名') ]
      ),
    );
    hot = place;
    try {
      loadHotTopState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getHotTop();
      hot = result;
      loadHotTopState = LoadState.success;
    } catch (e) {
      loadHotTopState = LoadState.error;
    }
    notifyListeners();
  }
  /// 加载榜单
  Future<void> loadRankList() async {
    List<RankListModel> place = List.generate(
      10,
          (_) => RankListModel(
          id: random.nextInt(100),
          name: '排行榜',
          coverImgUrl: 'lib/assets/image/banner.jpg',
      ),
    );
    rank = place;
    try {
      loadRankListState = LoadState.loading;
      notifyListeners();
      final result = await HomeService.getRankList();
      rank = result;
      loadRankListState = LoadState.success;
    } catch (e) {
      loadRankListState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> showSongInfoSheet (BuildContext context, SongBaseModel song) async {
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
                        onTap: () {
                          if (song.artistList.length > 1) {
                            Navigator.pop(sheetContext);
                            _showArtistPickerSheet(context, song);
                          } else {
                            Navigator.pop(sheetContext);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: const RouteSettings(
                                  name: "/ArtistDetail",
                                ),
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => ArtistDetailProvider(),
                                  child: ArtistDetail(artistId: song.artistList[0].id),
                                ),
                              ),
                            );
                          }
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
                                      CupertinoIcons.music_mic,
                                      color: YMusicColors.primary,
                                      size: 25
                                  ),
                                  SizedBox(
                                    width: YMusicSpacing.md,
                                  ),
                                  Text(
                                      '歌手：${song.artistNames}',
                                      style: YMusicTextStyles.body,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                      const Divider(
                        height: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.white12,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: const RouteSettings(
                                name: "/AlbumDetail",
                              ),
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => AlbumDetailProvider(),
                                child: AlbumDetail(albumId: song.album.id),
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: YMusicSpacing.sm,
                                vertical: YMusicSpacing.lg,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                      CupertinoIcons.square_stack_3d_down_right,
                                      color: YMusicColors.primary,
                                      size: 25
                                  ),
                                  SizedBox(
                                    width: YMusicSpacing.md,
                                  ),
                                  Text(
                                      '专辑：${song.album.name}',
                                      style: YMusicTextStyles.body,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                      const Divider(
                        height: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.white12,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: YMusicSpacing.sm,
                              vertical: YMusicSpacing.lg,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                    CupertinoIcons.cloud_download,
                                    color: YMusicColors.primary,
                                    size: 25
                                ),
                                SizedBox(
                                  width: YMusicSpacing.md,
                                ),
                                Text(
                                    '下载',
                                    style: YMusicTextStyles.body
                                )
                              ],
                            ),
                          )
                      )
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

  Future<void> _showArtistPickerSheet(
      BuildContext context,
      SongBaseModel song,
      ) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 520),
            padding: EdgeInsetsGeometry.only(bottom: 35),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E).withOpacity(0.96),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: YMusicSpacing.md),
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
                  padding: const EdgeInsets.fromLTRB(
                    YMusicSpacing.lg,
                    YMusicSpacing.lg,
                    YMusicSpacing.lg,
                    YMusicSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Text('选择歌手', style: YMusicTextStyles.title3),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: YMusicSpacing.lg),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '这首歌由多个歌手参与演唱',
                      style: YMusicTextStyles.artistName,
                    ),
                  ),
                ),
                const SizedBox(height: YMusicSpacing.md),
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      YMusicSpacing.md,
                      0,
                      YMusicSpacing.md,
                      YMusicSpacing.md,
                    ),
                    itemCount: song.artistList.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: Colors.white12,
                    ),
                    itemBuilder: (context, index) {
                      final artist = song.artistList[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: const RouteSettings(
                                name: "/ArtistDetail",
                              ),
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => ArtistDetailProvider(),
                                child: ArtistDetail(artistId: song.artistList[0].id),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: YMusicSpacing.sm,
                            vertical: YMusicSpacing.lg,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  artist.name.isNotEmpty ? artist.name.characters.first : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: YMusicSpacing.md),
                              Expanded(
                                child: Text(
                                  artist.name,
                                  style: YMusicTextStyles.body,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white.withOpacity(0.35),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}