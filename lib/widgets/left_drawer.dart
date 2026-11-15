import 'package:flutter/material.dart';
import 'package:salink_mobile/screens/menu.dart';
import 'package:salink_mobile/screens/saling_beli/saling_beli_page.dart';
import 'package:salink_mobile/screens/saling_pinjam/saling_pinjam_page.dart';
import 'package:salink_mobile/screens/saling_bagi/saling_bagi_page.dart';
import 'package:salink_mobile/screens/saling_tebeng/saling_tebeng_page.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'SaLink Mobile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Platform Berbagi & Kolaborasi Kampus UI',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Modul Layanan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined, color: Colors.indigo),
            title: const Text('Saling Beli (Preloved & Hibah)'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalingBeliPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.handyman_outlined, color: Colors.teal),
            title: const Text('Saling Pinjam (Alat & Barang)'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalingPinjamPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.fastfood_outlined, color: Colors.orange),
            title: const Text('Saling Bagi (Makanan Berlebih)'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalingBagiPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car_outlined, color: Colors.deepPurple),
            title: const Text('Saling Tebeng (Nebeng Kampus)'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalingTebengPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
