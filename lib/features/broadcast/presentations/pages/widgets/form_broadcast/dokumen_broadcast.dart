import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:file_picker/file_picker.dart'; // Uncomment jika sudah install
import '../../../providers/broadcast_form_provider.dart';

class DokumenBroadcastField extends ConsumerWidget {
  final Color primaryColor;

  const DokumenBroadcastField({
    super.key,
    this.primaryColor = const Color(0xFF6C63FF),
  });

  Future<void> _pickFile(WidgetRef ref) async {
    ScaffoldMessenger.of(ref.context).showSnackBar(
      const SnackBar(content: Text('Fitur pilih file belum dipasang (butuh file_picker)')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(broadcastFormProvider);
    final hasFile = formState.dokumenPath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dokumen Lampiran (Opsional)',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hasFile ? primaryColor.withOpacity(0.1) : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                hasFile ? Icons.description : Icons.upload_file,
                color: hasFile ? primaryColor : Colors.grey[500],
              ),
            ),
            title: Text(
              hasFile 
                ? formState.dokumenPath!.split('/').last 
                : 'Upload PDF/Dokumen',
              style: TextStyle(
                color: hasFile ? Colors.black87 : Colors.grey[500],
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: hasFile
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      ref.read(broadcastFormProvider.notifier).updateDokumenPath(null);
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.add_circle_outline, color: primaryColor),
                    onPressed: () => _pickFile(ref),
                  ),
            onTap: () => _pickFile(ref),
          ),
        ),
      ],
    );
  }
}