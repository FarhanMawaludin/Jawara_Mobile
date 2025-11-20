import 'package:flutter/material.dart';

class CardRumah extends StatelessWidget {
  final String blok;
  final String nomorRumah;
  final String alamatLengkap;

  const CardRumah({
    super.key,
    required this.blok,
    required this.nomorRumah,
    required this.alamatLengkap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _item("Blok", blok),
          const SizedBox(height: 16),
          _item("Nomor Rumah", nomorRumah),
          const SizedBox(height: 16),
          _item("Alamat Lengkap", alamatLengkap),
        ],
      ),
    );
  }

  Widget _item(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          softWrap: true,
        ),
      ],
    );
  }
}
