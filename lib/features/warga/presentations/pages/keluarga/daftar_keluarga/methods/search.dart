import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  late TextEditingController controller;
  late ProviderSubscription<String> subscription; // <-- penting

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(
      text: ref.read(searchInputProvider),
    );

    // Listen provider di initState HARUS pakai listenManual
    subscription = ref.listenManual<String>(
      searchInputProvider,
      (previous, next) {
        if (controller.text != next) {
          controller.text = next;
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    subscription.close(); // wajib ditutup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // TEXTFIELD
        Expanded(
          flex: 5,
          child: TextField(
            controller: controller,
            onChanged: (value) {
              ref.read(searchInputProvider.notifier).state = value;
            },
            decoration: InputDecoration(
              hintText: 'Cari keluarga...',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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

        // BUTTON SEARCH
        InkWell(
          onTap: () {
            final value = controller.text.trim();
            ref.read(searchKeywordProvider.notifier).state = value;
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

        // FILTER ICON
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Icon(
            HeroiconsOutline.funnel,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
