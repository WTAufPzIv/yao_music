import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/set_list_detail.dart';

class LocalPlaylistStorage {
  static const String _storageKey = 'ymusic_local_playlists';

  static Future<List<LocalSetListDetailModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => LocalSetListDetailModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<LocalSetListDetailModel> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(playlists.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }
}