import 'package:get/get.dart';

class ConfirmationController extends GetxController {
  final confirmationMessage = 'SUCCESS!'.obs;

  String finalRoute = '/home';

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      confirmationMessage.value = Get.arguments['message'] ?? 'SUCCESS!';
    }

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(finalRoute);
    });
  }
}
