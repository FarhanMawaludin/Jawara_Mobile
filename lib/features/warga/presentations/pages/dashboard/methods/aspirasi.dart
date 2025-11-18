import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class Aspirasi extends StatelessWidget {
  const Aspirasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Pesan Warga",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      context.push('/warga/aspirasi');
                    },
                    child: Text(
                      "Lihat Semua",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurpleAccent[400],
                      ),
                    ),
                  ),
                  Icon(
                    HeroiconsMini.chevronRight,
                    size: 24,
                    color: Colors.deepPurpleAccent[400],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // List Pesan
          _buildMessageTile(
            imageUrl:
                'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
            name: 'John Doe',
            message: 'Selamat pagi, semoga harimu menyenangkan!',
            time: '2 jam lalu',
          ),
          _buildMessageTile(
            imageUrl:
                'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
            name: 'Jane Smith',
            message: 'Terima kasih atas bantuanmu kemarin!',
            time: '5 jam lalu',
          ),
        ],
      ),
    );
  }

  // Komponen ListTile supaya bisa dipakai ulang
  Widget _buildMessageTile({
    required String imageUrl,
    required String name,
    required String message,
    required String time,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.grey[300]!, width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey[900],
        ),
      ),
      subtitle: Text(
        message,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w400,
          color: Colors.grey[600],
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
