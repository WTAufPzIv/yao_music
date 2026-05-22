import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../user/user_page.dart';
import 'main_page.dart';

class MainPageState extends State<MainPage> {

  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
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