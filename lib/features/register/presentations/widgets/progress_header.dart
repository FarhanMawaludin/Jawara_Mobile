// lib/presentation/widgets/progress_header.dart
import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressHeader({super.key, required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        return Expanded(
          child: Container(
            height: 4,
            color: index < currentStep ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }
}