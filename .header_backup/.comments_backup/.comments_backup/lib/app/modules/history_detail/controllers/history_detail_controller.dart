import 'package:ai_dream_interpretation/app/models/history_item_model.dart';
import 'package:get/get.dart';

class HistoryDetailController extends GetxController {
  // This will hold the conversation data passed from the history list.
  final historyItem = Rxn<HistoryItem>();

  @override
  void onInit() {
    super.onInit();
    // Receive the HistoryItem from the arguments when the page loads.
    if (Get.arguments is HistoryItem) {
      historyItem.value = Get.arguments;
    }
  }
}
