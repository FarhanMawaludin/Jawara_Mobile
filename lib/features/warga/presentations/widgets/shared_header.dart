import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class SharedHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showGreeting;
  final bool showNotification;

  const SharedHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showGreeting = false,
    this.showNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showGreeting ? 'Selamat pagi,' : (subtitle ?? ''),
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2), // Reduced height
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18, // Reduced font size
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showNotification)
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                icon: const Icon(HeroiconsMini.bell, size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
      ),
    );
  }
}
