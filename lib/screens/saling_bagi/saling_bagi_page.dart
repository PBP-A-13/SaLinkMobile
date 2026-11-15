import 'package:flutter/material.dart';

class SalingBagiPage extends StatelessWidget {
  const SalingBagiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saling Bagi'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fastfood_outlined, size: 80, color: Colors.orange.shade300),
              const SizedBox(height: 16),
              const Text(
                'Modul Saling Bagi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Redistribusi makanan berlebih yang masih layak konsumsi di lingkungan kampus.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Chip(
                backgroundColor: Colors.orange.shade50,
                label: const Text(
                  'Checkpoint 1: Scoping & Kerangka Modul',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
