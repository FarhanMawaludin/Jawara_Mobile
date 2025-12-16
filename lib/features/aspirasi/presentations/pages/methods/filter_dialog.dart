import 'package:flutter/material.dart';

Future<String?> showAspirationFilterDialog(
  BuildContext context, {
  required String currentStatus,
  required Function(String) onApply,
}) {
  final statuses = ['All', 'Pending', 'In Progress', 'Resolved'];
  String tempStatus = currentStatus;

  return showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Filter Aspirasi',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Status'),
              const SizedBox(height: 6),
              for (final s in statuses)
                RadioListTile<String>(
                  dense: true,
                  title: Text(
                    s,
                    style: TextStyle(
                      color: tempStatus == s ? Colors.deepPurpleAccent[400] : null,
                    ),
                  ),
                  value: s,
                  groupValue: tempStatus,
                  activeColor: Colors.deepPurpleAccent[400],
                  onChanged: (v) => setState(() => tempStatus = v ?? 'All'),
                ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() => tempStatus = 'All'),
                icon: Icon(Icons.clear, size: 18, color: Colors.grey[700]),
                label: Text('Reset filter', style: TextStyle(color: Colors.grey[800])),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.grey[800]),
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              onApply(tempStatus);
              Navigator.pop(context);
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    ),
  );
}
