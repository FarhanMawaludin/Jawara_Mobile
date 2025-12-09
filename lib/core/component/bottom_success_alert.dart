import 'package:flutter/material.dart';

class BottomSuccessAlert extends StatelessWidget {
  final String title;
  final String message;
  final Widget? icon;

  const BottomSuccessAlert({
    super.key,
    required this.title,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ===== TITLE =====
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              /// ===== MESSAGE =====
              Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              /// ===== ICON / ANIMATION =====
              if (icon != null) ...[
                icon!,
                const SizedBox(height: 16),
              ],

            ],
          ),
        ),
      ),
    );
  }
}

void showBottomSuccessAlert({
  required BuildContext context,
  required String title,
  required String message,
  Widget? icon,
  required VoidCallback onComplete,
  Duration duration = const Duration(seconds: 1),
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    isDismissible: false,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 350, // UBAH INI: 0.8, 0.9, 1.0, atau nilai fixed seperti 350
        child: BottomSuccessAlert(
          title: title,
          message: message,
          icon: icon,
        ),
      );
    },
  );

 
  Future.delayed(duration, () {
    if (context.mounted) {
      Navigator.pop(context); 
      onComplete(); 
    }
  });
}