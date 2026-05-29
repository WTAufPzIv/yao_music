import '../models/login.dart';
import 'base/dio_http.dart';

class LoginApi {
  /// 登录手机号密码
  static Future<UserModel> fetchLoginPP(LoginPPDTO params) async {
    final results = await DioHttp.dio.get(
      '/login/cellphone?phone=${params.phone}&password=${params.password}&realIP=116.25.146.177',
    );
    if (results.data?['data']?['profile'] != null) {
      return UserModel.fromJson(results.data?['data']?['profile']);
    } else {
      return UserModel(
        userId: 0,
        avatarUrl: '',
        signature: '',
        backgroundUrl: '',
        nickname: results.data?['message'],
      );
    }
  }
  // 登录手机号验证码
  static Future<UserModel> fetchLoginPC(LoginPCDTO params) async {
    final results = await DioHttp.dio.get(
      '/login/cellphone?phone=${params.phone}&captcha=${params.captcha}',
    );
    if (results.data?['data']?['profile'] != null) {
      return UserModel.fromJson(results.data?.data?.profile);
    } else {
      return UserModel(
        userId: 0,
        avatarUrl: '',
        signature: '',
        backgroundUrl: '',
        nickname: results.data?['message'],
      );
    }
  }
  // 获取验证码
  static Future<dynamic> fetchCaptcha(String phone) async {
    final results = await DioHttp.dio.get(
      '/captcha/sent?phone=${phone}',
    );
    return results;
  }
  // 获取登陆状态
  static Future<LoginStatusModel> fetchLoginStatus() async {
    final result1 = await DioHttp.dio.get('/login/status');
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    print(result1);
    if (result1.data?['data']?['profile']?['userId'] != null) {
      final result2 = await DioHttp.dio.get('/user/playlist?uid=${result1.data?['data']?['profile']?['userId']}');
      return LoginStatusModel.fromJson({
        'userinfo': result1.data?['data']?['profile'],
        'setList': result2.data?['playlist']
      });
    } else {
      return LoginStatusModel(
        userinfo: UserModel(
          userId: 0,
          avatarUrl: '',
          signature: '',
          backgroundUrl: '',
          nickname: '',
        ),
        setList: []
      );
    }
  }
  // 退出登录
  static Future<dynamic> fetchLogout() async {
    final results = await DioHttp.dio.get(
      '/logout',
    );
    return results;
  }
}