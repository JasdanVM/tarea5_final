import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final RxString _languageCode = ''.obs;

  @override
  void onInit() {
    langCode = GetStorage().read('language') ?? '&language=es-ES';

    super.onInit();
  }

  String get langCode => _languageCode.value;
  set langCode(value) => _languageCode.value = value;
}