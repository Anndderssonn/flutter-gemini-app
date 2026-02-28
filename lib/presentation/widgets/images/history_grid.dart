import 'package:flutter/material.dart';
import 'package:flutter_gemini_app/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryGrid extends ConsumerWidget {
  const HistoryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generatedHistory = ref.watch(generatedHistoryProvider);
    final selectedImage = ref.watch(selectedImageProvider);

    return GridView.builder(
      itemCount: generatedHistory.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final imageUrl = generatedHistory[index];

        return GestureDetector(
          onTap: () {
            ref.read(selectedImageProvider.notifier).setSelectedImage(imageUrl);
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                width: selectedImage == imageUrl ? 4 : 0,
                color: selectedImage == imageUrl ? Colors.blue : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
