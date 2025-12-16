import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../providers/broadcast_form_provider.dart';

class DokumenBroadcastField extends ConsumerWidget {
  final Color primaryColor;

  const DokumenBroadcastField({
    super.key,
    this.primaryColor = const Color(0xFF6C63FF),
  });

  Future<void> _pickFile(WidgetRef ref, BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;
        final fileSize = result.files.single.size;
        
        // Check file size (max 10MB)
        if (fileSize > 10 * 1024 * 1024) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ukuran file terlalu besar! Maksimal 10MB'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        ref.read(broadcastFormProvider.notifier).updateDokumenPath(filePath);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dokumen berhasil dipilih: $fileName'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih file: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(broadcastFormProvider);
    final hasFile = formState.dokumenPath != null;
    
    // Get file name from path
    final fileName = hasFile 
        ? formState.dokumenPath!.split('\\').last.split('/').last
        : 'Upload PDF/Dokumen';

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
            border: Border.all(
              color: hasFile ? primaryColor.withOpacity(0.3) : Colors.grey.shade200,
              width: hasFile ? 1.5 : 1,
            ),
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
              fileName,
              style: TextStyle(
                color: hasFile ? Colors.black87 : Colors.grey[500],
                fontSize: 14,
                fontWeight: hasFile ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: hasFile 
                ? const Text(
                    'Tap untuk ganti dokumen',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  )
                : const Text(
                    'PDF, DOC, XLS (Max 10MB)',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
            trailing: hasFile
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      ref.read(broadcastFormProvider.notifier).updateDokumenPath(null);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dokumen dihapus'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  )
                : Icon(Icons.add_circle_outline, color: primaryColor),
            onTap: () => _pickFile(ref, context),
          ),
        ),
      ],
    );
  }
}