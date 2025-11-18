import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TagihanPage extends StatelessWidget {
  const TagihanPage({super.key});

  final List<Map<String, dynamic>> iuranList = const [
    {
      "nama": "Keluarga Raudhli Firdaus Naufal",
      "kategori": "Mingguan",
      "tanggal": "30 September 2025",
      "nominal": 50000,
      "status": "Belum Bayar"
    },
    {
      "nama": "Keluarga Raudhli Firdaus Naufal",
      "kategori": "Agustusan",
      "tanggal": "10 Oktober 2025",
      "nominal": 50000,
      "status": "Belum Bayar"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iuran"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.print)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: iuranList.length,
        itemBuilder: (context, index) {
          final item = iuranList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item["nama"],
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(item["kategori"]),
                      const SizedBox(width: 16),
                      const Icon(Icons.date_range, size: 16),
                      const SizedBox(width: 4),
                      Text(item["tanggal"]),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp ${item["nominal"]}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(item["status"],
                            style: const TextStyle(color: Colors.amber)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          context.push('/keuangan/tagihan/detail', extra: item);
                        },
                        child: const Text("Detail"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
