import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  void _handleFilter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Aspirasi'),
        content: const Text('Opsi filter akan ditampilkan di sini'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.search, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Cari...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          GestureDetector(
            onTap: () => _handleFilter(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.filter_list, size: 20, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
