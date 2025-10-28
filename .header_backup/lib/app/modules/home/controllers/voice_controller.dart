import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ai_dream_interpretation/constants.dart';

class VoiceController extends GetxController {
  final types = <String>[].obs;
  final selected = ''.obs;
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    loadSaved();
    fetchVoiceTypes();
  }

  Future<void> fetchVoiceTypes() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/chatbot/voice-types/'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final list = data['available_voice_types'] as List?;
        if (list != null) {
          types.value = list.map((e) => e.toString()).toList();
          if (selected.isEmpty && types.isNotEmpty) {
            selected.value = types.first;
          }
        }
      } else {
        
      }
    } catch (e) {
      
    }
  }

  Future<void> loadSaved() async {
    final v = await _storage.read(key: 'voice_type');
    if (v != null && v.isNotEmpty) selected.value = v;
  }

  Future<void> setSelected(String type) async {
    selected.value = type;
    await _storage.write(key: 'voice_type', value: type);

    
    try {
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken != null && accessToken.isNotEmpty) {
        final multipart = http.MultipartRequest(
          'PATCH',
          Uri.parse('$baseUrl/auth/login/'),
        );
        multipart.fields['voice_type'] = type;
        multipart.headers['Authorization'] = 'Bearer $accessToken';
        final streamed = await multipart.send();
        final resp = await http.Response.fromStream(streamed);
        if (resp.statusCode == 200 || resp.statusCode == 201) {
          
        } else {
          
        }
      }
    } catch (e) {
      
    }
  }
}
