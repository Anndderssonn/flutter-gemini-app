import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

part 'user_provider.g.dart';

@riverpod
types.User geminiUser(Ref ref) {
  final geminiUser = types.User(
    id: 'gemini-id-123',
    firstName: 'Gemini',
    imageUrl: 'https://picsum.photos/id/179/200/200',
  );
  return geminiUser;
}

@riverpod
types.User user(Ref ref) {
  final user = types.User(
    id: 'user-id-123',
    firstName: 'Bruce',
    lastName: 'Banner',
    imageUrl: 'https://picsum.photos/id/177/200/200',
  );
  return user;
}
