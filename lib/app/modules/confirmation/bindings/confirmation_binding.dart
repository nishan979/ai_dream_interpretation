import 'package:get/get.dart';

import '../controllers/confirmation_controller.dart';

class ConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmationController>(
      () => ConfirmationController(),
    );
  }
}
