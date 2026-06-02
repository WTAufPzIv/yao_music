import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/login.dart';
import '../../../providers/set_list_provider.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_space.dart';
import '../../../theme/app_text.dart';
import '../../set_list_detail/set_list_detail.dart';

class SetListCard extends StatelessWidget {
  final UserSetListModel setList;
  const SetListCard({
    super.key,
    required this.setList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/SetListDetail"),
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => SetListProvider(),
                    child: SetListDetail(
                      setListId: setList.id,
                    ),
                  ),
                ),
              );
            },
            child: _buildCover(),
          ),
          const SizedBox(height: YMusicSpacing.md),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Text(
              setList.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: YMusicTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    final pic = setList.picUrl ?? '';
    if (pic.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(YMusicRadius.md),
        child: CachedNetworkImage(
            imageUrl: '$pic?param=300y300',
            httpHeaders: {'user-agent': 'windows'},
            width: 180,
            height: 180,
            fit: BoxFit.cover
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(YMusicRadius.md),
      child: Image.asset(
        pic,
        width: 180,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: 180,
            height: 180,
            color: Colors.white10,
            child: const Icon(Icons.music_note, color: Colors.white54, size: 46),
          );
        },
      ),
    );
  }
}