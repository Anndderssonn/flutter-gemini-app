import 'package:flutter/material.dart';
import 'package:flutter_gemini_app/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_gemini_app/presentation/providers/providers.dart';

class ChatContextScreen extends ConsumerWidget {
  const ChatContextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final messages = ref.watch(chatWithContextProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversational Chat'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(chatWithContextProvider.notifier).newChat();
            },
            icon: Icon(Icons.clear_outlined),
          ),
        ],
      ),
      body: Chat(
        messages: messages,
        onSendPressed: (_) {},
        user: user,
        theme: DarkChatTheme(),
        showUserNames: true,
        customBottomWidget: CustomBottomInput(
          onSend: (prompt, {images = const []}) {
            ref
                .read(chatWithContextProvider.notifier)
                .addMessage(partialText: prompt, user: user, images: images);
          },
        ),
      ),
    );
  }
}
