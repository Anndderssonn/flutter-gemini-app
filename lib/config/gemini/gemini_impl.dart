import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiImpl {
  final Dio _http = Dio(BaseOptions(baseUrl: dotenv.env['ENDPOINT_API'] ?? ''));

  Future<String> getResponse(String prompt) async {
    try {
      final body = {'prompt': prompt};
      final response = await _http.post(
        '/basic-prompt',
        data: jsonEncode(body),
      );
      return response.data;
    } catch (error) {
      throw Exception('No response could be obtained from Gemini');
    }
  }

  Stream<String> getResponseStream(String prompt) async* {
    final body = {'prompt': prompt};
    final response = await _http.post(
      '/basic-prompt-stream',
      data: jsonEncode(body),
      options: Options(responseType: ResponseType.stream),
    );
    final stream = response.data.stream as Stream<List<int>>;
    String buffer = '';
    await for (final chunk in stream) {
      final chunkString = utf8.decode(chunk, allowMalformed: true);
      buffer += chunkString;
      yield buffer;
    }
  }
}
