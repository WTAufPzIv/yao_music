import 'package:flutter/material.dart';
import 'user_page.dart';

class UserPageState extends State<UserPage> {
  int count = 0;

  void add() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('这是测试页面'),
      ),
      body: Center(
        child: Text(
          "$count",
          style: const TextStyle(fontSize: 40),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: const Icon(Icons.add),
      ),
    );
  }
}
