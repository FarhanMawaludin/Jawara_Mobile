import 'package:flutter/material.dart';
import 'methods/aspirasi.dart';
import 'methods/card.dart';
import 'methods/itemmenu.dart';


class WargaPage extends StatelessWidget {
  const WargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CardWarga(),
                const SizedBox(height: 20),
                Itemmenu(),
                const SizedBox(height: 20),
                Aspirasi(),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
