import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gemini_app/presentation/providers/providers.dart';

part 'basic_chat.g.dart';

final uuid = Uuid();

@riverpod
class BasicChat extends _$BasicChat {
  @override
  List<Message> build() {
    return [];
  }

  void addMessage({required PartialText partialText, required User user}) {
    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User author) {
    final message = TextMessage(
      author: author,
      id: uuid.v4(),
      text: partialText.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = [message, ...state];
    _geminiTextResponse(partialText.text);
  }

  void _geminiTextResponse(String prompt) async {
    final geminiUser = ref.read(geminiUserProvider);
    final isGeminiWriting = ref.read(isGeminiWritingProvider.notifier);
    isGeminiWriting.setIsWriting();
    await Future.delayed(Duration(seconds: 2));
    isGeminiWriting.setIsNotWriting();
    final message = TextMessage(
      author: geminiUser,
      id: uuid.v4(),
      text: 'Hello world from Gemini: $prompt',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = [message, ...state];
  }
}
