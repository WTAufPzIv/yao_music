import 'package:flutter/material.dart';
import 'package:yao_music/pages/home/home_page.dart';
import '../../components/mini_player.dart';
import '../../components/overlay.dart';
import '../../theme/app_color.dart';
import '../home/home_page_navigator.dart';
import '../home/home_wrapper.dart';
import '../search/search_page.dart';
import '../search/search_page_navigator.dart';
import '../search/search_wrapper.dart';
import '../user/user_page.dart';
import '../user/user_page_navigator.dart';
import 'main_page.dart';

class MainPageState extends State<MainPage> {

  int currentIndex = 0;

  final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> searchNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> userNavigatorKey = GlobalKey<NavigatorState>();

  late final pages = [
    const HomePage(),
    const SearchPageWrapper(),
    const UserPage(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      MiniPlayerOverlay.show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: pages,
            ),
          ),
          // MiniPlayer(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: YMusicColors.bottomBarActive,
        unselectedItemColor: YMusicColors.bottomBarInactive,
        backgroundColor: YMusicColors.bottomBarBackground,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '搜索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}