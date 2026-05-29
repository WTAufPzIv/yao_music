import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yao_music/constants/load_state.dart';

import '../../models/login.dart';
import '../../providers/login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final cookieController = TextEditingController();

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    phoneController.dispose();
    codeController.dispose();
    cookieController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _sendCaptcha(LoginProvider provider) async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;

    await provider.loadCaptcha(phone);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('验证码已发送')),
    );
  }

  Future<void> _loginByCaptcha(LoginProvider provider) async {
    final phone = phoneController.text.trim();
    final captcha = codeController.text.trim();
    if (phone.isEmpty || captcha.isEmpty) return;

    UserModel loginRes = await provider.loadLoginPC(LoginPCDTO(
        phone: phone,
        captcha: captcha
    ));

    if (loginRes.userId > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('登录成功')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('登录失败：${loginRes.nickname}')),
      );
    }
  }

  Future<void> _loginByPassword(LoginProvider provider) async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    if (phone.isEmpty || password.isEmpty) return;
    
    try {
      UserModel loginRes = await provider.loadLoginPP(LoginPPDTO(
          phone: phone,
          password: password
      ));

      if (loginRes.userId > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登录成功')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登录失败：${loginRes.nickname}')),
        );
      }
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> _loginByCookie(LoginProvider provider) async {
    final cookie = cookieController.text.replaceAll('set-cookie:', '').replaceAll('Set-Cookie:', '').trim();
    if (cookie.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入Cookie')),
      );
      return;
    }
    try {
      await provider.loadLoginCookie(cookie);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff1f1f1f),
                  Color(0xff101010),
                  Color(0xff2b0f15),
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(color: Colors.black.withOpacity(0.15)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Icon(
                            CupertinoIcons.back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '登录',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '登录后同步你的音乐与歌单',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: TabBar(
                                    controller: _tabController,
                                    dividerColor: Colors.transparent,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelPadding: EdgeInsets.zero,
                                    splashFactory: NoSplash.splashFactory,
                                    overlayColor: WidgetStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      color: const Color(0xffff375f),
                                    ),
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.white.withOpacity(0.6),
                                    labelStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    tabs: const [
                                      Tab(
                                        child: SizedBox.expand(
                                          child: Center(
                                            child: Text('验证码登录'),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: SizedBox.expand(
                                          child: Center(
                                            child: Text('密码登录'),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: SizedBox.expand(
                                          child: Center(
                                            child: Text('Cookie登录'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 300,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      _buildCaptchaLogin(provider),
                                      _buildPasswordLogin(provider),
                                      _buildCookieLogin(provider),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptchaLogin(LoginProvider provider) {
    final loginLoadingState = provider.loginLoadingState == LoadState.loading;
    return Column(
      children: [
        _input(
          controller: phoneController,
          hint: '请输入手机号',
          prefix: CupertinoIcons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _input(
                controller: codeController,
                hint: '请输入验证码',
                prefix: CupertinoIcons.number,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.12),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: loginLoadingState ? null : () => _sendCaptcha(provider),
                child: const Text('发送'),
              ),
            ),
          ],
        ),
        const Spacer(),
        _loginButton(
          text: loginLoadingState ? '登录中...' : '登录',
          onTap: loginLoadingState ? null : () => _loginByCaptcha(provider),
        ),
      ],
    );
  }

  Widget _buildPasswordLogin(LoginProvider provider) {
    final loginLoadingState = provider.loginLoadingState == LoadState.loading;
    return Column(
      children: [
        _input(
          controller: phoneController,
          hint: '请输入手机号',
          prefix: CupertinoIcons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _input(
          controller: passwordController,
          hint: '请输入密码',
          prefix: CupertinoIcons.lock,
          obscureText: !passwordVisible,
          suffix: GestureDetector(
            onTap: () => setState(() => passwordVisible = !passwordVisible),
            child: Icon(
              passwordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
              color: Colors.white.withOpacity(0.6),
              size: 20,
            ),
          ),
        ),
        const Spacer(),
        _loginButton(
          text: loginLoadingState ? '登录中...' : '登录',
          onTap: loginLoadingState ? null : () => _loginByPassword(provider),
        ),
      ],
    );
  }

  Widget _buildCookieLogin(LoginProvider provider) {
    final loginLoadingState =
        provider.loginLoadingState == LoadState.loading;
    return Column(
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: cookieController,
            maxLines: null,
            expands: true,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
              hintText: '请粘贴网易云Cookie',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '支持 MUSIC_U / __csrf 等完整 Cookie',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 12,
            ),
          ),
        ),
        const Spacer(),
        _loginButton(
          text: loginLoadingState ? '登录中...' : 'Cookie登录',
          onTap: loginLoadingState
              ? null
              : () => _loginByCookie(provider),
        ),
      ],
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData prefix,
    Widget? suffix,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: Icon(prefix, color: Colors.white.withOpacity(0.6), size: 20),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget _loginButton({
    required String text,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffff375f),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}