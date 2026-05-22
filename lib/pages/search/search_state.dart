import 'package:flutter/material.dart';
import 'search_page.dart';

class SomePageState extends State<SearchPage> {
  String markPageName = '这是搜索页';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('搜索'),
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
