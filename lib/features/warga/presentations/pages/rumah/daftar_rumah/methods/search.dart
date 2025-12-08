import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/features/warga/presentations/providers/rumah/rumah_providers.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchRumahWidgetState();
}

class _SearchRumahWidgetState extends ConsumerState<Search> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final input = ref.watch(searchRumahInputProvider);

    if (controller.text != input) {
      controller.text = input;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextField(
            controller: controller,
            onChanged: (value) {
              ref.read(searchRumahInputProvider.notifier).state = value;
            },
            decoration: InputDecoration(
              hintText: 'Cari rumah...',
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {
            ref.read(searchRumahKeywordProvider.notifier).state =
                controller.text.trim();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent[400],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     border: Border.all(color: Colors.grey.shade300),
        //   ),
        //   child: Icon(
        //     HeroiconsOutline.funnel,
        //     color: Colors.grey[800],
        //   ),
        // ),
      ],
    );
  }
}
