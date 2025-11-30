import 'package:flutter/material.dart';

class DaftarKegiatanPage extends StatefulWidget {
  const DaftarKegiatanPage({super.key});

  @override
  State<DaftarKegiatanPage> createState() => _DaftarKegiatanPageState();
}

class _DaftarKegiatanPageState extends State<DaftarKegiatanPage> {
  // Dummy data - Replace with your Provider/Repository data
  final List<Map<String, String>> _kegiatanList = [
    {
      'id': '1',
      'nama': 'Kerja Bakti Desa',
      'tanggal': '01 Des 2025',
      'lokasi': 'Balai Desa',
      'status': 'Akan Datang'
    },
    {
      'id': '2',
      'nama': 'Rapat Karang Taruna',
      'tanggal': '05 Des 2025',
      'lokasi': 'Aula Utama',
      'status': 'Selesai'
    },
    {
      'id': '3',
      'nama': 'Posyandu Balita',
      'tanggal': '10 Des 2025',
      'lokasi': 'Pos 1',
      'status': 'Akan Datang'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Kegiatan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[50],
      body: _kegiatanList.isEmpty
          ? Center(
              child: Text(
                'Belum ada kegiatan',
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _kegiatanList.length,
              itemBuilder: (context, index) {
                final item = _kegiatanList[index];
                return _buildSwipeableCard(item, index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to TambahKegiatanPage
          // Navigator.pushNamed(context, '/tambah_kegiatan');
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSwipeableCard(Map<String, String> item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key(item['id']!),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_outline, color: Colors.white, size: 28),
              Text("Hapus",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Konfirmasi Hapus"),
                content: Text(
                    "Apakah Anda yakin ingin menghapus kegiatan '${item['nama']}'?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Batal",
                        style: TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Hapus",
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          setState(() {
            _kegiatanList.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${item['nama']} dihapus")),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.event_note, color: Colors.purple),
            ),
            title: Text(
              item['nama']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(item['tanggal']!,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(item['lokasi']!,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item['status'] == 'Selesai'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item['status']!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: item['status'] == 'Selesai'
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}