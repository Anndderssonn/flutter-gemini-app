import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gemini_app/config/config.dart';
import 'package:flutter_gemini_app/presentation/presentation.dart';

part 'generated_images_provider.g.dart';

@Riverpod(keepAlive: true)
class GeneratedImages extends _$GeneratedImages {
  final GeminiImpl gemini = GeminiImpl();
  late final IsGenerating isGeneratingNotifier;
  late final GeneratedHistory generatingHistoryNotifier;

  String previousPrompt = '';
  List<XFile> previousFiles = [];

  @override
  List<String> build() {
    isGeneratingNotifier = ref.read(isGeneratingProvider.notifier);
    generatingHistoryNotifier = ref.read(generatedHistoryProvider.notifier);
    return [];
  }

  void addImage(String imageUrl) {
    if (imageUrl == '') return;
    generatingHistoryNotifier.addImage(imageUrl);
    state = [...state, imageUrl];
  }

  void clearImages() {
    state = [];
  }

  Future<void> generateImage(
    String prompt, {
    List<XFile> files = const [],
  }) async {
    isGeneratingNotifier.setIsGenerating();
    final imageUrl = await gemini.generateImage(prompt, files: files);
    previousPrompt = prompt;
    previousFiles = files;
    addImage(imageUrl ?? '');
    isGeneratingNotifier.setIsNotGenerating();
    if (state.length == 1) {
      generateImageWighPreviousPrompt();
    }
  }

  Future<void> generateImageWighPreviousPrompt() async {
    if (previousPrompt.isEmpty) return;
    await generateImage(previousPrompt, files: previousFiles);
  }
}
