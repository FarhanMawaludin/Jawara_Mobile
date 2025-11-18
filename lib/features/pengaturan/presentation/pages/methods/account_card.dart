import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: const Icon(Icons.person, color: Colors.deepPurple),
        ),
        title: const Text('Nama Pengguna'),
        subtitle: const Text('user@example.com'),
        trailing: TextButton(
          onPressed: () {
            // Handle edit profile action
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Edit profil')));
          },
          child: const Text('Edit'),
        ),
      ),
    );
  }
}
