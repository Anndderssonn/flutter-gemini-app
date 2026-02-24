import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gemini_app/presentation/providers/providers.dart';
import 'package:flutter_gemini_app/config/config.dart';

part 'chat_with_context.g.dart';

final uuidChatProvider = Uuid();

@Riverpod(keepAlive: true)
class ChatWithContext extends _$ChatWithContext {
  final gemini = GeminiImpl();
  late User geminiUser;
  late String chatId;

  @override
  List<Message> build() {
    geminiUser = ref.read(geminiUserProvider);
    chatId = uuidChatProvider.v4();
    return [];
  }

  void addMessage({
    required PartialText partialText,
    required User user,
    List<XFile> images = const [],
  }) {
    if (images.isNotEmpty) {
      _addTextMessageWithImages(partialText, user, images);
      return;
    }
    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User author) {
    _crateTextMessage(partialText.text, author);
    _geminiTextResponseStream(partialText.text);
  }

  Future<void> _addTextMessageWithImages(
    PartialText partialText,
    User author,
    List<XFile> images,
  ) async {
    for (XFile image in images) {
      _crateImageMessage(image, author);
    }
    await Future.delayed(Duration(milliseconds: 10));
    _crateTextMessage(partialText.text, author);
    _geminiTextResponseStream(partialText.text, images: images);
  }

  void _geminiTextResponseStream(
    String prompt, {
    List<XFile> images = const [],
  }) async {
    _crateTextMessage('Gemini is processing...', geminiUser);
    gemini.getChatResponseStream(prompt, chatId, files: images).listen((event) {
      if (event.isEmpty) return;
      final updatedMessages = [...state];
      final updatedMessage = (updatedMessages.first as TextMessage).copyWith(
        text: event,
      );
      updatedMessages[0] = updatedMessage;
      state = updatedMessages;
    });
  }

  void newChat() {
    chatId = uuidChatProvider.v4();
    state = [];
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

  Future<void> _crateImageMessage(XFile image, User author) async {
    final message = ImageMessage(
      author: author,
      id: uuid.v4(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      uri: image.path,
      name: image.name,
      size: await image.length(),
    );
    state = [message, ...state];
  }
}
