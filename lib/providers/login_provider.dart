  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/load_state.dart';
import '../models/login.dart';
import '../services/login_service.dart';

class LoginProvider extends ChangeNotifier {
   static LoginStatusModel init = LoginStatusModel(
      userinfo: UserModel(
          userId: 0,
          nickname: '',
          avatarUrl: '',
          backgroundUrl: '',
          signature: ''
      ),
      setList: []
  );
  LoginStatusModel userinfo = init;
  LoadState loadState = LoadState.loading;
  LoadState loginLoadingState = LoadState.loading;
  LoadState logoutLoadingState = LoadState.loading;
  LoadState captchaLoadingState = LoadState.loading;

    /// 获取登录信息
   Future<void> loadLoginStatus() async {
     try {
       loadState = LoadState.loading;
       notifyListeners();
       final result = await LoginService.getLoginStatus();
       userinfo = result;
       loadState = LoadState.success;
     } catch (e) {
       loadState = LoadState.error;
     }
     notifyListeners();
   }

  /// PP登录
   Future<UserModel> loadLoginPP(LoginPPDTO params) async {
     return await LoginService.getLoginPP(params);
   }

   /// PC登录
   Future<void> loadLoginPC(LoginPCDTO params) async {
     await LoginService.getLoginPC(params);
   }

   /// 获取验证码
   Future<void> loadCaptcha(String phone) async {
     await LoginService.getCaptcha(phone);
   }

   /// 登出
   Future<void> loadLout() async {
     await LoginService.getLogout();
   }
}