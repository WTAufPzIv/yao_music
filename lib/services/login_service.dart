import 'package:yao_music/api/login.dart';

import '../models/login.dart';

class LoginService {
  /// 登录手机号密码
  static Future<UserModel> getLoginPP(LoginPPDTO params) async {
    final result = await LoginApi.fetchLoginPP(params);
    return result;
  }
  /// 登录手机号密码
  static Future<UserModel> getLoginPC(LoginPCDTO params) async {
    final result = await LoginApi.fetchLoginPC(params);
    return result;
  }
  /// 获取验证码
  static Future<dynamic> getCaptcha(String phone) async {
    final result = await LoginApi.fetchCaptcha(phone);
    return result;
  }
  /// 获取登陆状态
  static Future<LoginStatusModel> getLoginStatus() async {
    final result = await LoginApi.fetchLoginStatus();
    return result;
  }
  /// 退出登录
  static Future<dynamic> getLogout() async {
    final result = await LoginApi.fetchLogout();
    return result;
  }
}