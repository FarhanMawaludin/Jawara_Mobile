import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PemasukanLainPage extends StatelessWidget {
  const PemasukanLainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pemasukan Lain"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
       actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF635BFF), // Warna ungu seperti contoh
                borderRadius: BorderRadius.circular(12), // Membuat kotak rounded
              ),
            child: IconButton(
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: Colors.white, // warna icon jadi putih
              ),
              onPressed: () {},
              ),
            ),
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Raudhli Firdaus Naufal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Icons.wallet_rounded, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Pendapatan Lainnya"),
                    SizedBox(width: 10),
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("13 Oktober 2025"),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Rp 500.000",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push('/keuangan/pemasukan-lain/detail'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Detail"),
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
