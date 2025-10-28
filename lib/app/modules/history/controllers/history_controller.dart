
import 'dart:convert';
import 'package:ai_dream_interpretation/app/models/history_item_model.dart';
import 'package:ai_dream_interpretation/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HistoryController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final historyItems = <HistoryItem>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    print("[DEBUG] 1. Starting to fetch history...");
    try {
      isLoading.value = true;
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        Get.snackbar('Error', 'You are not logged in.');
        isLoading.value = false;
        return;
      }
      print("[DEBUG] 2. Using Access Token: $accessToken");

      final response = await http.get(
        Uri.parse('$baseUrl/chatbot/history/'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      print("[DEBUG] 3. Response Status Code: ${response.statusCode}");
      print("[DEBUG] 4. Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        historyItems.value = data.map((item) => HistoryItem.fromJson(item)).toList();
        print("[DEBUG] 5. Successfully parsed ${historyItems.length} items.");
      } else {
        Get.snackbar('Error', 'Failed to load history.');
      }
    } catch (e) {
      print("[DEBUG] 6. An error occurred in the try-catch block: $e");
      Get.snackbar('Error', 'Could not connect to the server.');
    } finally {
      isLoading.value = false;
      print("[DEBUG] 7. Finished fetching history.");
    }
  }
}
