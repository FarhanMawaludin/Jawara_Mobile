import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/tagihiuran.dart';
import 'package:jawaramobile/features/keuangan/presentations/widgets/pdf/tagihan_pdf_generator.dart';

class TagihanPage extends StatelessWidget {
  TagihanPage({super.key});

  final List<TagihIuran> iuranList = [
    TagihIuran(
      id: 1,
      createdAt: DateTime.now(),
      kategoriId: "Mingguan",
      jumlah: 50000,
      tanggalTagihan: DateTime(2025, 9, 30),
      nama: "Keluarga Raudhli Firdaus Naufal",
      keluargaId: 1,
      statusTagihan: "Belum Bayar",
      buktiBayar: null,
      tanggalBayar: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iuran"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                TagihanPdfGenerator.printPDF(iuranList);
              },
              icon: const Icon(Icons.print)),
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
                  Text(
                    item.nama,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  // Row kategori + tanggal
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(item.kategoriId),
                      const SizedBox(width: 16),
                      const Icon(Icons.date_range, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${item.tanggalTagihan.day}-${item.tanggalTagihan.month}-${item.tanggalTagihan.year}",
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Nominal
                  Text(
                    "Rp ${item.jumlah}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),

                  const SizedBox(height: 8),

                  // Status + Detail button
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
                        child: Text(
                          item.statusTagihan,
                          style: const TextStyle(color: Colors.amber),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          context.push(
                            '/keuangan/tagihan/detail',
                            extra: item,
                          );
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
