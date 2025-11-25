import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KategoriIuranPage extends StatelessWidget {
  const KategoriIuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dataIuran = [
      {'nama': 'Kerja Bakti', 'harga': 50000, "tipe": "Iuran Bulanan"},
      {'nama': 'Iuran Kebersihan', 'harga': 20000, "tipe": "Iuran Bulanan"},
      {'nama': 'Agustusan', 'harga': 30000, "tipe": "Iuran Khusus"},
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Iuran'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(''),
        ),
      ),
     body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        "Iuran Bulanan:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text("Dibayar setiap bulan sekali secara rutin."),
                  SizedBox(height: 8),
                  Text(
                    "Iuran Khusus:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "Dibayar sesuai kebutuhan tertentu, misalnya acara khusus, renovasi, dsb."),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/keuangan/iuran/tambah-iuran'),
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Iuran"),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Filter"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: dataIuran.length,
                itemBuilder: (context, index) {
                  final item = dataIuran[index];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.receipt_long),
                      ),
                      title: Text(item["nama"]),
                      subtitle: Text(
                        "Rp ${item["harga"]}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Chip(
                        label: Text(item["tipe"]),
                        backgroundColor: item["tipe"] == "Iuran Bulanan"
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        side: BorderSide(
                          color: item["tipe"] == "Iuran Bulanan"
                              ? Colors.blue
                              : Colors.orange,
                        ),
                        labelStyle: TextStyle(
                          color: item["tipe"] == "Iuran Bulanan"
                              ? Colors.blue
                              : Colors.orange,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}