import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/pages/search/search_page.dart';
import 'package:yao_music/providers/search_provider.dart';

class SearchPageWrapper extends StatelessWidget {
  const SearchPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: const SearchResult(),
    );
  }
}