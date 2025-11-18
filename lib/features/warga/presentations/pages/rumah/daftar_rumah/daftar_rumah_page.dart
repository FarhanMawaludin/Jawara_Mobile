import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'methods/card_rumah.dart';
import 'methods/search.dart';

class DaftarRumahPage extends StatelessWidget {
  const DaftarRumahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(HeroiconsMini.arrowLeft),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Daftar Rumah',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey[300], height: 1),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Search(),
                const SizedBox(height: 20),
                CardRumah(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}