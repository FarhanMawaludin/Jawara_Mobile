import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'methods/card_alasan.dart';
import 'methods/card_mutasi.dart';
import 'methods/judul_detail.dart';

class DetailMutasiPage extends StatelessWidget {
  const DetailMutasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Detail Mutasi',
              style: TextStyle(fontWeight: FontWeight.w500)),
          leading: IconButton(
            icon: const Icon(HeroiconsMini.arrowLeft),
            onPressed: () => context.pop(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey[300], height: 1),
          ),
          titleSpacing: 0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                JudulDetail(),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Detail Mutasi",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 12),
                      CardMutasi(),
                      const SizedBox(height: 12),
                      CardAlasan(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}