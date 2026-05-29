import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';

final storage = FlutterSecureStorage();

class DioHttp {
  static late Dio dio;
  static late PersistCookieJar cookieJar;
  static String? cookie;
  static const String cookieKey = 'music_cookie';
  static Future<void> init() async {
    cookie = await storage.read(key: cookieKey);
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (cookie != null && cookie!.isNotEmpty) {
            options.headers['cookie'] = cookie;
          }
          handler.next(options);
        },
      ),
    );
  }
  static Future<void> setCookie(String value) async {
    cookie = value;
    await storage.write(
      key: cookieKey,
      value: value
    );
  }

  static Future<void> clearCookie() async {
    cookie = null;
    await storage.deleteAll();
  }
}