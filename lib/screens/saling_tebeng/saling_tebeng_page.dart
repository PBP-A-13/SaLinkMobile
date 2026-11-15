import 'package:flutter/material.dart';

class SalingTebengPage extends StatelessWidget {
  const SalingTebengPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saling Tebeng'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_car_outlined, size: 80, color: Colors.deepPurple.shade300),
              const SizedBox(height: 16),
              const Text(
                'Modul Saling Tebeng',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Berbagi perjalanan motor & mobil di area kampus UI.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Chip(
                backgroundColor: Colors.deepPurple.shade50,
                label: const Text(
                  'Checkpoint 1: Scoping & Kerangka Modul',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
