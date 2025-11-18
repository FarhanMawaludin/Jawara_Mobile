import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_section.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/search_section.dart';


class AspirationPage extends StatelessWidget {
  const AspirationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom header to match screenshot: back arrow + centered title
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Back button (use the same BackButton used in detail page)
                    InkWell( onTap: () => context.pop(), child: const Icon(Icons.arrow_back, color: Colors.black),),
                    const SizedBox(width: 8),
                    const Text(
                      'Aspirasi',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),

          // Sticky search (kept outside scrollable list)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: const SearchSection(),
          ),

          // Content area (list scrolls independently)
          const Expanded(
            child: AspirationListSection(),
          ),
        ],
      ),
    );
  }
}
