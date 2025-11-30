import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart'; // Uncomment jika sudah install
import '../../../providers/broadcast_form_provider.dart';

class FotoBroadcastField extends ConsumerWidget {
  final Color primaryColor;

  const FotoBroadcastField({
    super.key,
    this.primaryColor = const Color(0xFF6C63FF),
  });

  Future<void> _pickImage(WidgetRef ref) async {
    ScaffoldMessenger.of(ref.context).showSnackBar(
      const SnackBar(content: Text('Fitur pilih galeri belum dipasang (butuh image_picker)')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(broadcastFormProvider);
    final hasImage = formState.fotoPath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Lampiran (Opsional)',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickImage(ref),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasImage ? primaryColor : Colors.grey.shade300,
                width: hasImage ? 1.5 : 1,
              ),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(formState.fotoPath!),
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Center(
                              child: Icon(Icons.broken_image, color: Colors.grey)),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 16,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.close, size: 18, color: Colors.white),
                              onPressed: () {
                                ref.read(broadcastFormProvider.notifier).updateFotoPath(null);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          size: 40, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'Ketuk untuk upload foto',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}