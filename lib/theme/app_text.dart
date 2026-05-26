import 'package:flutter/material.dart';

import 'app_color.dart';

class YMusicTextStyles  {
  /// 超大标题
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: YMusicColors.textPrimary,
    letterSpacing: -0.5,
  );
  /// 一级标题
  static const TextStyle title1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: YMusicColors.textPrimary,
  );

  /// 二级标题
  static const TextStyle title2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: YMusicColors.textPrimary,
  );

  /// 三级标题
  static const TextStyle title3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: YMusicColors.textPrimary,
  );

  /// 路由标题
  static const TextStyle router = TextStyle(
    fontSize: 22,
    color: YMusicColors.textPrimary,
  );

  /// 正文大
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: YMusicColors.textPrimary,
    height: 1.4,
  );

  /// 正文标准
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: YMusicColors.textPrimary,
    height: 1.4,
  );

  /// 正文小
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: YMusicColors.textSecondary,
    height: 1.3,
  );
  /// 辅助文字
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: YMusicColors.textHint,
  );

  /// 超小辅助文字
  static const TextStyle captionSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: YMusicColors.textHint,
  );

  /// 按钮文字
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: YMusicColors.textPrimary,
  );

  /// 歌曲标题
  static const TextStyle songTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: YMusicColors.textPrimary,
  );

  /// 歌手名
  static const TextStyle artistName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: YMusicColors.textSecondary,
  );

  /// 专辑名
  static const TextStyle albumName = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: YMusicColors.textHint,
  );
}