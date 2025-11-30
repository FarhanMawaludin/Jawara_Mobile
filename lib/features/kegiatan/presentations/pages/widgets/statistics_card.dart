import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'status_item.dart';

class StatisticsCard extends StatelessWidget {
  final int totalKegiatan;
  final int selesai;
  final int hariIni;
  final int akanDatang;

  const StatisticsCard({
    super.key,
    required this.totalKegiatan,
    required this.selesai,
    required this.hariIni,
    required this.akanDatang,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Total Kegiatan
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalKegiatan',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Kegiatan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Status Row
          Row(
            children: [
              Expanded(
                child: StatusItem(
                  icon: Icons.check,
                  iconColor: Colors.blue,
                  label: 'Selesai',
                  value: '$selesai',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatusItem(
                  icon: Icons.refresh,
                  iconColor: Colors.orange,
                  label: 'Hari Ini',
                  value: '$hariIni',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatusItem(
                  icon: Icons.calendar_today,
                  iconColor: Colors.green,
                  label: 'Akan Datang',
                  value: '$akanDatang',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
        ],
      ),
    );
  }
}