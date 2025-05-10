import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:hackathon_prepare/kakao_login.dart';

class KakaoLoginViewModel {
  final ILogin _iLogin;

  KakaoLoginViewModel(this._iLogin);

  // 1. 현재 로그인 상태 체크
  bool isLogined = false;

  // 2. 카카오톡 User 정보 가져오기
  User? user;

  // 3. 로그인 기능
  Future<void> login() async {
    isLogined = await _iLogin.login();
    print('로그인기능 $isLogined');

    // 3-1. 로그인이 성공했다면
    try {
      if (isLogined) {
        user = await UserApi.instance.me();
      }
    } catch (e) {
      print(e);
    }
  }

  // 4. 로그아웃 기능
  Future<void> logout() async {
    await _iLogin.logout();
    isLogined = false;
    user = null;
  }
}
