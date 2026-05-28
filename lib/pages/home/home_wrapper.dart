import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import 'home_page.dart';

class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: const HomePage(),
    );
  }
}