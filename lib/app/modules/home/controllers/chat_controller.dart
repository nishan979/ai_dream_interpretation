import 'dart:convert';
import 'package:ai_dream_interpretation/app/models/chat_message_model.dart';
import 'package:ai_dream_interpretation/app/modules/auth/controllers/auth_controller.dart';
import 'package:ai_dream_interpretation/constants.dart';
import 'package:ai_dream_interpretation/resources/widgets/bubble_type.dart';
import 'package:ai_dream_interpretation/utils/tts_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class ChatController extends GetxController {
  final AuthController _authController = Get.find();
  final _storage = const FlutterSecureStorage();

  final messages = <ChatMessageModel>[].obs;
  final isTyping = false.obs;

  String? accessToken;
  String? dreamText;
  bool hasAnswered = false;

  final String _apiUrl = '$baseUrl/chatbot/dream/';
  final String _voiceApiUrl = '$baseUrl/chatbot/voice/';

  @override
  void onInit() {
    super.onInit();
    _loadToken();
    messages.insert(
      0,
      ChatMessageModel(
        text:
            'Hi, I am AI Dream Interpreter. Please tell me about your dream...',
        type: BubbleType.ai,
      ),
    );
  }

  // a fyup i d ----------------------------------
  void onMessageReceived(String text) {
    // send to TTS
    TtsManager.instance.speak(text);
    // ...existing code...
  }

  // ----------------------

  Future<void> _loadToken() async {
    accessToken = await _storage.read(key: 'access_token');
  }

  void setTyping(bool value) => isTyping.value = value;

  Future<void> sendMessage({required String text}) async {
    if (text.isEmpty) return;

    messages.insert(0, ChatMessageModel(text: text, type: BubbleType.user));
    messages.insert(
      0,
      ChatMessageModel(text: 'Interpreting your dream...', type: BubbleType.ai),
    );

    try {
      Map<String, String> body = {};
      final currentUserType = _authController.userType.value;

      if (!hasAnswered) {
        body = {"text": text, "user_type": currentUserType};
        dreamText = text;
      } else {
        body = {
          "text": dreamText ?? '',
          "answers": text,
          "user_type": currentUserType,
        };
      }

      final request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
      request.fields.addAll(
        body.map((key, value) => MapEntry(key, value.toString())),
      );

      if (accessToken != null && accessToken!.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      messages.removeAt(0);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        if (!hasAnswered) {
          final interpretation =
              responseData['interpretation'] ?? 'No interpretation found.';
          final questions = responseData['questions'] ?? '';

          messages.insert(
            0,
            ChatMessageModel(text: interpretation, type: BubbleType.ai),
          );

          if (questions.isNotEmpty) {
            messages.insert(
              0,
              ChatMessageModel(text: questions, type: BubbleType.ai),
            );
          }

          hasAnswered = true;
        } else {
          final ultimateAns =
              responseData['interpretation'] ?? 'No ultimate answer found.';

          messages.insert(
            0,
            ChatMessageModel(text: ultimateAns, type: BubbleType.ai),
          );
        }
      } else if (response.statusCode == 429) {
        String backendMessage = 'Your limit finished for today';
        try {
          final responseData = json.decode(response.body);
          if (responseData is Map<String, dynamic>) {
            backendMessage =
                responseData['message']?.toString() ??
                responseData['detail']?.toString() ??
                responseData['error']?.toString() ??
                responseData['data']?.toString() ??
                backendMessage;
          } else if (responseData is String && responseData.isNotEmpty) {
            backendMessage = responseData;
          }
        } catch (e) {
          // ignore: could not parse backend message
        }

        messages.insert(
          0,
          ChatMessageModel(text: backendMessage, type: BubbleType.ai),
        );
      } else {
        messages.insert(
          0,
          ChatMessageModel(
            text: 'Sorry, I encountered an error. Please try again.',
            type: BubbleType.ai,
          ),
        );
      }
    } catch (e) {
      messages.removeAt(0);
      messages.insert(
        0,
        ChatMessageModel(
          text: 'I seem to be offline. Please check your connection.',
          type: BubbleType.ai,
        ),
      );
    }
  }

  Future<void> pickAndTranscribeAudio() async {
    try {
      var status = await Permission.audio.request();
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      if (status.isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.audio,
        );

        if (result != null && result.files.single.path != null) {
          PlatformFile file = result.files.first;

          const allowedExtensions = ['mp3', 'wav', 'm4a', 'aac'];
          final fileExtension = file.extension?.toLowerCase();

          if (fileExtension == null ||
              !allowedExtensions.contains(fileExtension)) {
            messages.insert(
              0,
              ChatMessageModel(
                text: 'Please select a valid audio file (mp3, wav, m4a, aac).',
                type: BubbleType.ai,
              ),
            );
            return;
          }

          messages.insert(
            0,
            ChatMessageModel(text: "🎵 ${file.name}", type: BubbleType.user),
          );
          messages.insert(
            0,
            ChatMessageModel(
              text: 'Interpreting your dream...',
              type: BubbleType.ai,
            ),
          );

          var request = http.MultipartRequest('POST', Uri.parse(_voiceApiUrl));
          request.files.add(
            await http.MultipartFile.fromPath('voice', file.path!),
          );

          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);

          messages.removeAt(0);

          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);
            final interpretation =
                responseData['dreamExplanation'] ??
                'I am not sure how to interpret that.';

            messages.insert(
              0,
              ChatMessageModel(text: interpretation, type: BubbleType.ai),
            );
          } else {
            messages.insert(
              0,
              ChatMessageModel(
                text: 'Sorry, I couldn’t process that audio.',
                type: BubbleType.ai,
              ),
            );
          }
        }
      } else if (status.isPermanentlyDenied) {
        // No-op; permission denied
      } else {
        messages.insert(
          0,
          ChatMessageModel(
            text: 'Audio access is required to pick audio files.',
            type: BubbleType.ai,
          ),
        );
      }
    } catch (e) {
      messages.insert(
        0,
        ChatMessageModel(
          text: 'An unexpected error occurred.',
          type: BubbleType.ai,
        ),
      );
    }
  }
}
