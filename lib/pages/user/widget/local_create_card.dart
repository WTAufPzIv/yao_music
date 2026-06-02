import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yao_music/theme/app_color.dart';

import '../../../models/set_list_detail.dart';

class LocalCreateCard extends StatefulWidget {
  final Future<void> Function(LocalSetListDetailModel item) inertLocalPlayList;
  const LocalCreateCard({super.key, required this.inertLocalPlayList});

  @override
  State<LocalCreateCard> createState() => _LocalCreateCardState();
}

class _LocalCreateCardState extends State<LocalCreateCard> {
  final TextEditingController _playlistNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _playlistNameController.dispose();
  }

  Future<void> createLocalPlaylist(BuildContext context) async {
    _playlistNameController.clear();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xff1c1c1e),
          title: const Text(
            '创建本地歌单',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _playlistNameController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '请输入歌单名称',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xffff375f)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                '取消',
                style: TextStyle(color: Colors.white.withOpacity(0.75)),
              ),
            ),
            TextButton(
              onPressed: () {
                final value = _playlistNameController.text.trim();
                if (value.isEmpty) return;
                Navigator.pop(dialogContext, value);
              },
              child: const Text(
                '创建',
                style: TextStyle(color: Color(0xffff375f)),
              ),
            ),
          ],
        );
      }
    );
    if (name == null || name.trim().isEmpty) return;
    final randomId = DateTime.now().millisecondsSinceEpoch + Random().nextInt(99999);
    final playlistItem = LocalSetListDetailModel(
        id: randomId,
        cover: 'https://picsum.photos/seed/$randomId/800/800',
        name: name.trim(),
        songs: []
    );
    widget.inertLocalPlayList(playlistItem);
  }

  @override
  Widget build(BuildContext context) {
   return Container(
     padding: const EdgeInsets.all(18),
     decoration: BoxDecoration(
       color: Colors.white.withOpacity(0.08),
       borderRadius: BorderRadius.circular(24),
       border: Border.all(color: Colors.white.withOpacity(0.08)),
     ),
     child: Row(
       children: [
         Container(
           width: 52,
           height: 52,
           decoration: BoxDecoration(
             color: YMusicColors.primary.withOpacity(0.18),
             borderRadius: BorderRadius.circular(16),
           ),
           child: const Icon(
             Icons.add,
             color: YMusicColors.primary,
             size: 30,
           ),
         ),
         const SizedBox(width: 14),
         Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const Text(
                 '创建本地歌单',
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 16,
                   fontWeight: FontWeight.w700,
                 ),
               )
             ],
           ),
         ),
         const SizedBox(width: 12),
         SizedBox(
           height: 42,
           child: ElevatedButton(
             style: ElevatedButton.styleFrom(
               backgroundColor: YMusicColors.primary,
               foregroundColor: Colors.white,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(14),
               ),
               elevation: 0,
             ),
             onPressed: () => createLocalPlaylist(context),
             child: const Text('新建'),
           ),
         ),
       ],
     ),
   );
  }
}