import 'package:flutter/material.dart';

class SalingPinjamPage extends StatelessWidget {
  const SalingPinjamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saling Pinjam'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.handyman_outlined, size: 80, color: Colors.teal.shade300),
              const SizedBox(height: 16),
              const Text(
                'Modul Saling Pinjam',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Akses sementara terhadap barang yang dibutuhkan mahasiswa UI.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Chip(
                backgroundColor: Colors.teal.shade50,
                label: const Text(
                  'Checkpoint 1: Scoping & Kerangka Modul',
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
