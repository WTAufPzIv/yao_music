import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

void nextFrame(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}

class DateUtil {
  static String formatDate(int timestamp) {
    return DateFormat('yyyy-MM-dd').format(
      DateTime.fromMillisecondsSinceEpoch(
        timestamp,
      ),
    );
  }
}