class LoginPPDTO {
  final String phone;
  final String password;

  LoginPPDTO({
    required this.phone,
    required this.password
  });
}

class LoginPCDTO {
  final String phone;
  final String captcha;

  LoginPCDTO({
    required this.phone,
    required this.captcha
  });
}

class UserModel {
  final int userId;
  final String nickname;
  final String avatarUrl;
  final String backgroundUrl;
  final String signature;

  UserModel({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
    required this.backgroundUrl,
    required this.signature,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final UserModel temp = UserModel(
      userId: json['userId'],
      nickname: json['nickname'],
      avatarUrl: json['avatarUrl'],
      backgroundUrl: json['backgroundUrl'],
      signature: json['signature'],
    );
    return temp;
  }
}

class UserSetListModel {
  /// id
  final int id;
  /// 歌单名称
  final String name;
  /// 歌单封面
  final String picUrl;

  UserSetListModel({
    required this.id,
    required this.name,
    required this.picUrl
  });

  factory UserSetListModel.fromJson(Map<String, dynamic> json) {
    return UserSetListModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      picUrl: json['coverImgUrl'] ?? '',
    );
  }
}

class LoginStatusModel {
  final UserModel userinfo;
  final List<UserSetListModel> setList;
  bool get isLogin {
    return userinfo.userId != null && userinfo.userId > 0;
  }

  LoginStatusModel({
    required this.userinfo,
    required this.setList
  });

  factory LoginStatusModel.fromJson(Map<String, dynamic> json) {
    final LoginStatusModel temp = LoginStatusModel(
      userinfo: UserModel.fromJson(json['userinfo']),
      setList: (json['setList'] as List<dynamic>?)
          ?.map((e) => UserSetListModel.fromJson(e))
          .toList() ?? [],
    );
    return temp;
  }
}