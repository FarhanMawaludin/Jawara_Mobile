import 'package:flutter/material.dart';

class BottomAlert extends StatelessWidget {
  final String title;
  final String message;

  final String yesText;
  final String? noText;

  final VoidCallback onYes;
  final VoidCallback? onNo;

  final bool onlyYes;

  final Widget? icon;

  const BottomAlert({
    super.key,
    required this.title,
    required this.message,
    required this.yesText,
    required this.onYes,
    this.noText,
    this.onNo,
    this.onlyYes = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView( // UNTUK ADAPTIF & ANTI OVERFLOW
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

              /// ===== ICON / IMAGE / GIF =====
              if (icon != null) ...[
                icon!,
                const SizedBox(height: 16),
              ],

              /// ===== BUTTON YES =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onYes,
                  child: Text(
                    yesText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              if (!onlyYes) ...[
                const SizedBox(height: 10),

                /// ===== BUTTON NO =====
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.deepPurpleAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onNo ?? () => Navigator.pop(context),
                    child: Text(
                      noText ?? "Tidak",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

void showBottomAlert({
  required BuildContext context,
  required String title,
  required String message,
  required String yesText,
  required VoidCallback onYes,
  String? noText,
  VoidCallback? onNo,
  bool onlyYes = false,
  Widget? icon,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) {
      return BottomAlert(
        title: title,
        message: message,
        yesText: yesText,
        noText: noText,
        onYes: onYes,
        onNo: onNo,
        onlyYes: onlyYes,
        icon: icon,
      );
    },
  );
}
