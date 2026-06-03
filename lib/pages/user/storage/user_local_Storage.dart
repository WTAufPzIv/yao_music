import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/set_list_detail.dart';

class LocalPlaylistStorage {
  static const String _storageKey = 'ymusic_local_playlists';
  static const String _filePrefix = 'ymusic_playlists_';
  static const String _fileExtension = '.json';
  static const Duration _fileReuseDuration = Duration(hours: 12);

  static Future<List<LocalSetListDetailModel>> load() async {
    final filePlaylists = await _loadFromLatestFile();
    if (filePlaylists != null) {
      print('LocalPlaylistStorage: loaded from local json file');
      return filePlaylists;
    }

    print('LocalPlaylistStorage: local json unavailable, loading from SharedPreferences');
    return _loadFromPrefs();
  }

  static Future<void> save(List<LocalSetListDetailModel> playlists) async {
    final raw = _encodePlaylists(playlists);

    await _saveToPrefs(raw);
    try {
      await _saveToFile(raw);
    } catch (_) {
      // SharedPreferences has already been written, so file storage can fail safely.
      print('LocalPlaylistStorage: local json save failed, SharedPreferences fallback saved');
    }
  }

  static Future<List<LocalSetListDetailModel>?> _loadFromLatestFile() async {
    final directory = await _getStorageDirectory();
    if (directory == null || !await directory.exists()) {
      return null;
    }

    final files = await _listPlaylistFiles(directory);
    for (final file in files) {
      try {
        final raw = await file.readAsString();
        final playlists = _decodePlaylists(raw);
        print('LocalPlaylistStorage: local json read success: ${file.path}');
        return playlists;
      } catch (_) {
        print('LocalPlaylistStorage: local json read failed: ${file.path}');
        continue;
      }
    }

    return null;
  }

  static Future<List<LocalSetListDetailModel>> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null || raw.isEmpty) {
      print('LocalPlaylistStorage: SharedPreferences empty');
      return [];
    }

    try {
      final playlists = _decodePlaylists(raw);
      print('LocalPlaylistStorage: SharedPreferences read success');
      return playlists;
    } catch (_) {
      print('LocalPlaylistStorage: SharedPreferences read failed');
      return [];
    }
  }

  static Future<void> _saveToPrefs(String raw) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, raw);
    print('LocalPlaylistStorage: saved to SharedPreferences');
  }

  static Future<void> _saveToFile(String raw) async {
    final directory = await _getStorageDirectory();
    if (directory == null) {
      return;
    }

    await directory.create(recursive: true);

    final files = await _listPlaylistFiles(directory);
    final latestFile = files.isEmpty ? null : files.first;
    final targetFile = _canReuseFile(latestFile)
        ? latestFile!
        : File(
            '${directory.path}${Platform.pathSeparator}'
            '${_buildFileName(DateTime.now())}',
          );

    final tempFile = File('${targetFile.path}.tmp');
    await tempFile.writeAsString(raw, flush: true);

    if (await targetFile.exists()) {
      await targetFile.delete();
    }
    await tempFile.rename(targetFile.path);
    print('LocalPlaylistStorage: saved to local json file: ${targetFile.path}');
  }

  static Future<Directory?> _getStorageDirectory() async {
    Directory? externalDirectory;
    try {
      externalDirectory = await getExternalStorageDirectory();
    } catch (_) {
      externalDirectory = null;
    }

    if (externalDirectory != null) {
      final visibleDirectory =
          _buildVisibleAndroidMediaDirectory(externalDirectory);
      if (visibleDirectory != null) {
        return visibleDirectory;
      }

      return Directory('${externalDirectory.path}${Platform.pathSeparator}playlists');
    }

    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      return Directory('${documentsDirectory.path}${Platform.pathSeparator}playlists');
    } catch (_) {
      return null;
    }
  }

  static Directory? _buildVisibleAndroidMediaDirectory(
    Directory externalDirectory,
  ) {
    if (!Platform.isAndroid) {
      return null;
    }

    final normalizedPath = externalDirectory.path.replaceAll('\\', '/');
    const marker = '/Android/data/';
    final markerIndex = normalizedPath.indexOf(marker);
    if (markerIndex == -1) {
      return null;
    }

    final packageStart = markerIndex + marker.length;
    final packageEnd = normalizedPath.indexOf('/', packageStart);
    if (packageEnd == -1) {
      return null;
    }

    final storageRoot = normalizedPath.substring(0, markerIndex);
    final packageName = normalizedPath.substring(packageStart, packageEnd);
    return Directory('$storageRoot/Android/media/$packageName/YMusic/playlists');
  }

  static Future<List<File>> _listPlaylistFiles(Directory directory) async {
    if (!await directory.exists()) {
      return [];
    }

    final files = <File>[];
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File) {
        continue;
      }

      final createdAt = _createdAtFromFileName(entity);
      if (createdAt != null) {
        files.add(entity);
      }
    }

    files.sort((a, b) {
      final aCreatedAt = _createdAtFromFileName(a)!;
      final bCreatedAt = _createdAtFromFileName(b)!;
      return bCreatedAt.compareTo(aCreatedAt);
    });

    return files;
  }

  static bool _canReuseFile(File? file) {
    if (file == null) {
      return false;
    }

    final createdAt = _createdAtFromFileName(file);
    if (createdAt == null) {
      return false;
    }

    return DateTime.now().difference(createdAt) < _fileReuseDuration;
  }

  static String _encodePlaylists(List<LocalSetListDetailModel> playlists) {
    return jsonEncode(playlists.map((e) => e.toJson()).toList());
  }

  static List<LocalSetListDetailModel> _decodePlaylists(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map(
          (e) => LocalSetListDetailModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  static String _buildFileName(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    return '$_filePrefix'
        '${_fourDigits(localTime.year)}'
        '${_twoDigits(localTime.month)}'
        '${_twoDigits(localTime.day)}_'
        '${_twoDigits(localTime.hour)}'
        '${_twoDigits(localTime.minute)}'
        '${_twoDigits(localTime.second)}'
        '$_fileExtension';
  }

  static DateTime? _createdAtFromFileName(File file) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final pattern = RegExp(
      '^${RegExp.escape(_filePrefix)}'
      r'(\d{8})_(\d{6})'
      '${RegExp.escape(_fileExtension)}\$',
    );
    final match = pattern.firstMatch(fileName);
    if (match == null) {
      return null;
    }

    final datePart = match.group(1)!;
    final timePart = match.group(2)!;
    final year = int.tryParse(datePart.substring(0, 4));
    final month = int.tryParse(datePart.substring(4, 6));
    final day = int.tryParse(datePart.substring(6, 8));
    final hour = int.tryParse(timePart.substring(0, 2));
    final minute = int.tryParse(timePart.substring(2, 4));
    final second = int.tryParse(timePart.substring(4, 6));

    if (year == null ||
        month == null ||
        day == null ||
        hour == null ||
        minute == null ||
        second == null) {
      return null;
    }

    return DateTime(year, month, day, hour, minute, second);
  }

  static String _fourDigits(int value) {
    return value.toString().padLeft(4, '0');
  }

  static String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }
}
