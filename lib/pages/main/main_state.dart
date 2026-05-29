import 'package:flutter/material.dart';
import 'package:yao_music/pages/home/home_page.dart';
import '../../components/mini_player.dart';
import '../../theme/app_color.dart';
import '../home/home_wrapper.dart';
import '../search/search_page.dart';
import '../search/search_wrapper.dart';
import '../user/user_page.dart';
import 'main_page.dart';

class MainPageState extends State<MainPage> {

  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const SearchPageWrapper(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayer(),
          BottomNavigationBar(
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
        ],
      )
    );
  }
}