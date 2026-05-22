import 'package:flutter/material.dart';
import 'user_page.dart';

class UserPageState extends State<UserPage> {
  String markPageName = "这是用户页面";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
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
