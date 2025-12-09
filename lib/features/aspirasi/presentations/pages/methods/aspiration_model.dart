import 'package:flutter/material.dart';

String formatDate(DateTime d) {
  const months = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return '${d.day} ${months[d.month]} ${d.year}';
}

Color statusColor(String s) {
  switch (s.toLowerCase()) {
    case 'diterima':
      return Colors.green.shade50;
    case 'pending':
      return Colors.yellow.shade50;
    case 'ditolak':
      return Colors.red.shade50;
    default:
      return Colors.grey.shade100;
  }
}

Color statusTextColor(String s) {
  switch (s.toLowerCase()) {
    case 'diterima':
      return Colors.green.shade700;
    case 'pending':
      return Colors.orange.shade800;
    case 'ditolak':
      return Colors.red.shade700;
    default:
      return Colors.black;
  }
}

class AspirationItem {
  final int? id;
  final String sender;
  final String title;
  final String status;
  final DateTime date;
  final String message;
  final bool isRead;

  AspirationItem({
    this.id,
    required this.sender,
    required this.title,
    required this.status,
    required this.date,
    required this.message,
    this.isRead = false,
  });
}
