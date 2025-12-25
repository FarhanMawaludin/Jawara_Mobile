import 'package:flutter/material.dart';

class AspirationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;
  final Function(String) onSearchChanged;

  const AspirationSearchBar({
    super.key,
    required this.controller,
    required this.onFilterTap,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final greyColor = Colors.grey[600];
    final boxDecoration = BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    );

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: boxDecoration,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            constraints: const BoxConstraints(minHeight: 44),
            child: Row(
              children: [
                Icon(Icons.search, size: 20, color: greyColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: Colors.grey.shade300,
                        cursorColor: Colors.grey.shade800,
                        selectionHandleColor: Colors.grey.shade600,
                      ),
                    ),
                    child: TextField(
                      key: const Key('aspiration_search_bar'),
                      controller: controller,
                      cursorColor: Colors.grey.shade800,
                      decoration: InputDecoration(
                        hintText: 'Cari pengirim atau judul...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(color: Colors.grey[800]),
                      onChanged: onSearchChanged,
                    ),
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return GestureDetector(
                      onTap: () {
                        controller.clear();
                        onSearchChanged('');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.close, size: 18, color: greyColor),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          key: const Key('filter_button'),
          onTap: onFilterTap,
          child: Container(
            height: 44,
            width: 44,
            decoration: boxDecoration,
            child: Center(
              child: Icon(Icons.filter_list, size: 20, color: greyColor),
            ),
          ),
        ),
      ],
    );
  }
}
