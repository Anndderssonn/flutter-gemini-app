import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gemini_app/presentation/providers/providers.dart';
import 'package:flutter_gemini_app/config/config.dart';

part 'basic_chat.g.dart';

final uuid = Uuid();

@riverpod
class BasicChat extends _$BasicChat {
  final gemini = GeminiImpl();
  late User geminiUser;

  @override
  List<Message> build() {
    geminiUser = ref.read(geminiUserProvider);
    return [];
  }

  void addMessage({required PartialText partialText, required User user}) {
    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User author) {
    _crateTextMessage(partialText.text, author);
    // _geminiTextResponse(partialText.text);
    _geminiTextResponseStream(partialText.text);
  }

  void _geminiTextResponse(String prompt) async {
    _setGeminiWritingStatus(true);
    final response = await gemini.getResponse(prompt);
    _setGeminiWritingStatus(false);
    _crateTextMessage(response, geminiUser);
  }

  void _geminiTextResponseStream(String prompt) async {
    _crateTextMessage('Gemini is processing...', geminiUser);
    gemini.getResponseStream(prompt).listen((event) {
      if (event.isEmpty) return;
      final updatedMessages = [...state];
      final updatedMessage = (updatedMessages.first as TextMessage).copyWith(
        text: event,
      );
      updatedMessages[0] = updatedMessage;
      state = updatedMessages;
    });
  }

  void _crateTextMessage(String text, User author) {
    final message = TextMessage(
      author: author,
      id: uuid.v4(),
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = [message, ...state];
  }

  void _setGeminiWritingStatus(bool isWriting) {
    final isGeminiWriting = ref.read(isGeminiWritingProvider.notifier);
    isWriting
        ? isGeminiWriting.setIsWriting()
        : isGeminiWriting.setIsNotWriting();
  }
}
