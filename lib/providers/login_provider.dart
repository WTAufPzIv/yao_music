  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/base/dio_http.dart';
import '../constants/load_state.dart';
import '../models/login.dart';
import '../services/login_service.dart';
import '../theme/app_color.dart';
import '../theme/app_space.dart';
import '../theme/app_text.dart';

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
  LoadState loginLoadingState = LoadState.empty;
  LoadState logoutLoadingState = LoadState.empty;
  LoadState captchaLoadingState = LoadState.empty;

    /// 获取登录信息
   Future<void> loadLoginStatus() async {
     try {
       notifyListeners();
       loadState = LoadState.loading;
       final result = await LoginService.getLoginStatus();
       userinfo = result;
       loadState = LoadState.success;
     } catch (e) {
       print(e.toString());
       loadState = LoadState.error;
     }
     notifyListeners();
   }

  /// PP登录
   Future<UserModel> loadLoginPP(LoginPPDTO params) async {
     try {
       loginLoadingState = LoadState.loading;
       notifyListeners();
       final result = await LoginService.getLoginPP(params);
       loginLoadingState = LoadState.success;
       notifyListeners();
       return result;
     } catch (e) {
       loginLoadingState = LoadState.error;
       notifyListeners();
       rethrow;
     }
   }

   /// PC登录
   Future<UserModel> loadLoginPC(LoginPCDTO params) async {
     try {
       loginLoadingState = LoadState.loading;
       notifyListeners();
       final result = await LoginService.getLoginPC(params);
       loginLoadingState = LoadState.success;
       notifyListeners();
       return result;
     } catch (e) {
       loginLoadingState = LoadState.error;
       notifyListeners();
       rethrow;
     }
   }

   /// cookie登录
   Future<void> loadLoginCookie(String cookie) async {
     await DioHttp.setCookie(cookie);
     await loadLoginStatus();
   }


   /// 获取验证码
   Future<void> loadCaptcha(String phone) async {
     await LoginService.getCaptcha(phone);
   }

   /// 登出
   Future<void> loadLout() async {
     DioHttp.clearCookie();
     await loadLoginStatus();
   }

   Future<void> showLogoutSheet (BuildContext context) async {
     showModalBottomSheet(
       context: context,
       backgroundColor: YMusicColors.background,
       isScrollControlled: true,
       builder: (sheetContext) {
         return SafeArea(
           child: Container(
             constraints: BoxConstraints(
               maxHeight: 500,
             ),
             padding: EdgeInsetsGeometry.only(bottom: 35),
             decoration: BoxDecoration(
               color: const Color(0xFF1C1C1E).withOpacity(0.94),
               borderRadius: const BorderRadius.vertical(
                 top: Radius.circular(28),
               ),
             ),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 /// 顶部拖拽条
                 Padding(
                   padding: const EdgeInsets.only(
                     top: YMusicSpacing.md,
                   ),
                   child: Container(
                     width: 36,
                     height: 5,
                     decoration: BoxDecoration(
                       color: Colors.white24,
                       borderRadius: BorderRadius.circular(999),
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(
                     horizontal: YMusicSpacing.md,
                     vertical: YMusicSpacing.md,
                   ),
                   child: Column(
                     children: [
                       InkWell(
                         borderRadius: BorderRadius.circular(12),
                         onTap: () async {
                           Navigator.pop(sheetContext);
                           await loadLout();
                         },
                         child: SizedBox(
                             width: double.infinity,
                             child: Padding(
                               padding: EdgeInsetsGeometry.symmetric(
                                 vertical: YMusicSpacing.lg,
                                 horizontal: YMusicSpacing.sm,
                               ),
                               child: Row(
                                 children: [
                                   Icon(
                                       CupertinoIcons.square_arrow_right,
                                       color: YMusicColors.primary,
                                       size: 25
                                   ),
                                   SizedBox(
                                     width: YMusicSpacing.md,
                                   ),
                                   Text(
                                       '退出登录',
                                       style: YMusicTextStyles.body,
                                       maxLines: 1,
                                       overflow: TextOverflow.ellipsis
                                   )
                                 ],
                               ),
                             )
                         ),
                       ),
                     ],
                   ),
                 )
               ],
             ),
           ),
         );
       },
     );
   }
}