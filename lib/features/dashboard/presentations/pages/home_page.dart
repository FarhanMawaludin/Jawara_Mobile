// lib/features/dashboard/presentations/pages/home_page.dart

import 'package:flutter/material.dart';
import '../widgets/ActivitiesSection.dart';
import '../widgets/FinanceSection.dart';
import '../widgets/HeaderSection.dart';
import '../widgets/PopulationCard.dart';
import '../widgets/log_aktivitas.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: const [
              HeaderSection(),
              SizedBox(height: 20),
              PopulationCard(),
              SizedBox(height: 20),
              ActivitiesSection(),
              SizedBox(height: 20),
              FinanceSection(),
              SizedBox(height: 20),
              RecentActivitiesSection(), 
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}