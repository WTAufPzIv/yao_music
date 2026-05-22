import 'package:flutter/material.dart';
import 'home_page.dart';

class HomePageState extends State<HomePage> {
  String markPageName = '这是首页';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: Center(
        child: Text(
          markPageName,
          style: const TextStyle(fontSize: 20),
        ),
      )
    );
  }
}
