import 'package:flutter/material.dart';
import 'package:salink_mobile/widgets/left_drawer.dart';
import 'package:salink_mobile/screens/saling_beli/saling_beli_page.dart';
import 'package:salink_mobile/screens/saling_pinjam/saling_pinjam_page.dart';
import 'package:salink_mobile/screens/saling_bagi/saling_bagi_page.dart';
import 'package:salink_mobile/screens/saling_tebeng/saling_tebeng_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaLink Mobile'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade600, Colors.indigo.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang di SaLink! 👋',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Platform berbagi & pemanfaatan kembali sumber daya lokal komunitas Universitas Indonesia.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Layanan Utama',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                color: Colors.indigo.shade50,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SalingBeliPage()),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.indigo,
                          child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saling Beli',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Katalog barang preloved dan hibah gratis mahasiswa UI.',
                                style: TextStyle(color: Colors.black87, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.indigo),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Modul Anggota Lain',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              _buildPlaceholderCard(
                context,
                'Saling Pinjam',
                'Akses sementara terhadap barang perkuliahan.',
                Icons.handyman_outlined,
                Colors.teal,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SalingPinjamPage())),
              ),
              _buildPlaceholderCard(
                context,
                'Saling Bagi',
                'Redistribusi makanan berlebih layak konsumsi.',
                Icons.fastfood_outlined,
                Colors.orange,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SalingBagiPage())),
              ),
              _buildPlaceholderCard(
                context,
                'Saling Tebeng',
                'Berbagi perjalanan motor/mobil rute kampus UI.',
                Icons.directions_car_outlined,
                Colors.deepPurple,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SalingTebengPage())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    MaterialColor color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
