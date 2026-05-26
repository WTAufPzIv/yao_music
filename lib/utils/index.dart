import 'dart:ui';

import 'package:flutter/cupertino.dart';

void nextFrame(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}