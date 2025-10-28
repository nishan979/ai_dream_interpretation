// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

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
    
    try {
      isLoading.value = true;
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        Get.snackbar('Error', 'You are not logged in.');
        isLoading.value = false;
        return;
      }
      

      final response = await http.get(
        Uri.parse('$baseUrl/chatbot/history/'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        historyItems.value = data
            .map((item) => HistoryItem.fromJson(item))
            .toList();
        
      } else {
        Get.snackbar('Error', 'Failed to load history.');
      }
    } catch (e) {
      
      Get.snackbar('Error', 'Could not connect to the server.');
    } finally {
      isLoading.value = false;
      
    }
  }
}
