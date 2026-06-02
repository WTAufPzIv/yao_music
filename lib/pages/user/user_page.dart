import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yao_music/pages/user/widget/header_info.dart';

import '../../theme/app_color.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YMusicColors.background,
      body: DefaultTabController(
        length: 2,
        child: HeaderInfo()
      ),
    );
  }
}