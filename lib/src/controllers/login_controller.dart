import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final RxString _userToken = ''.obs;
  final _userName = ''.obs;

  @override
  void onInit() {
    loginOutput = GetStorage().read('token') ?? '';
    userName = GetStorage().read('user') ?? '';

    super.onInit();
  }

  String get loginOutput => _userToken.value;
  set loginOutput(value) => _userToken.value = value;

  String get userName =>  _userName.value;
  set userName(value) =>  _userName.value = value;
}