import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

abstract class ILogin {
  Future<bool> login();
  Future<bool> logout();
}

class KakaoLogin implements ILogin {
  @override
  Future<bool> login() async {
    try {
      // 1. 카카오 install 여부 확인 : true / false
      bool isInstalled = await isKakaoTalkInstalled();
      // 1-1. install이 되어있다면, 카카오톡으로 로그인 유도
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (e) {
          return false;
        }
      } else {
        // 1-2. install이 되어있지 않다면, 카카오 계정으로 로그인 유도
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          return true;
        } catch (e) {
          print('카카오계정으로 로그인 실패 $e');
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      print('카카오톡 로그아웃 성공');
      return true;
    } catch (e) {
      return false;
    }
  }
}
