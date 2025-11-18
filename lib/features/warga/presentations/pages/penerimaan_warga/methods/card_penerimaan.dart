import 'package:flutter/material.dart';

class CardPenerimaan extends StatelessWidget {
  const CardPenerimaan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/justin_bieber.png',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Farhan Mawaludin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 4),
              Text('1234567890123456',style: TextStyle(fontSize: 12, color: Colors.grey[600]),),
              SizedBox(height: 4),
              Text('farhan@mail.com', style: TextStyle(fontSize: 12,color: Colors.grey[600]),),
              SizedBox(height: 4),
              Text('Laki-laki', style: TextStyle(fontSize: 12,color: Colors.grey[600]),),
            ],
          ),
        ],
      ),
    );
  }
}
