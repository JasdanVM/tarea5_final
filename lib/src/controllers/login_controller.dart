import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final RxString _userToken = ''.obs;

  @override
  void onInit() {
    //obener el valor del storage
    loginOutput = GetStorage().read('token') ?? '';

    super.onInit();
  }

  String get loginOutput => _userToken.value;
  set loginOutput(value) => _userToken.value = value;
}