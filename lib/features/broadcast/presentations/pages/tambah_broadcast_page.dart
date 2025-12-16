import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/exit.dart';
import '../providers/broadcast_form_provider.dart';
import 'widgets/form_broadcast/judul_broadcast.dart';
import 'widgets/form_broadcast/isi_broadcast.dart';
import 'widgets/form_broadcast/foto_broadcast.dart';
import 'widgets/form_broadcast/dokumen_broadcast.dart';
import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';

class TambahBroadcastPage extends ConsumerStatefulWidget {
  const TambahBroadcastPage({super.key});

  @override
  ConsumerState<TambahBroadcastPage> createState() => _TambahBroadcastPageState();
}

class _TambahBroadcastPageState extends ConsumerState<TambahBroadcastPage> {
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = const Color(0xFF6C63FF);
  bool _isSubmitting = false;

  Future<bool> _onWillPop() async {
    final formState = ref.read(broadcastFormProvider);

    if (formState.isEmpty) return true;

    final shouldPop = await DialogHelper.showConfirmation(
      context: context,
      title: 'Batalkan?',
      message: 'Pengumuman belum dikirim. Apakah Anda yakin ingin keluar?',
      confirmText: 'Keluar',
      cancelText: 'Lanjut Mengisi',
    );

    if (shouldPop == true) {
      ref.read(broadcastFormProvider.notifier).reset();
      return true;
    }

    return false;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    await DialogHelper.showLoading(context, message: 'Mengirim broadcast...');

    try {
      final result = await ref.read(broadcastFormProvider.notifier).submitForm();

      if (!mounted) return;

      DialogHelper.hideLoading(context);

      if (result['success'] == true) {
        // 🔥 BUAT LOG ACTIVITY SETELAH BERHASIL MEMBUAT BROADCAST
        final judulBroadcast = ref.read(broadcastFormProvider).judul;
        await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
          title: 'Membuat broadcast baru: $judulBroadcast',
        );

        DialogHelper.showSuccess(
          context,
          message: result['message'] ?? 'Broadcast berhasil dikirim!',
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) Navigator.pop(context);
      } else {
        DialogHelper.showError(
          context,
          result['message'] ?? 'Gagal mengirim broadcast',
        );
      }
    } catch (e) {
      if (!mounted) return;
      DialogHelper.hideLoading(context);
      DialogHelper.showError(context, 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Buat Broadcast',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Widget Judul
                  JudulBroadcastField(primaryColor: _primaryColor),
                  const SizedBox(height: 20),
                  
                  // 2. Widget Isi
                  IsiBroadcastField(primaryColor: _primaryColor),
                  const SizedBox(height: 20),

                  // 3. Widget Foto (Opsional)
                  FotoBroadcastField(primaryColor: _primaryColor),
                  const SizedBox(height: 20),

                  // 4. Widget Dokumen (Opsional)
                  DokumenBroadcastField(primaryColor: _primaryColor),
                  const SizedBox(height: 40),

                  // 5. Tombol Submit
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSubmitting ? Colors.grey : _primaryColor,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: _isSubmitting ? 0 : 2,
                        shadowColor: _primaryColor.withOpacity(0.4),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Kirim Broadcast',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}