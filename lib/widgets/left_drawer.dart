import 'package:flutter/material.dart';

import 'package:salink_mobile/theme/salink_colors.dart';
import 'package:salink_mobile/screens/menu.dart';
import 'package:salink_mobile/screens/auth/profile_page.dart';
import 'package:salink_mobile/screens/auth/login_page.dart';
import 'package:salink_mobile/services/auth_service.dart';

import 'package:salink_mobile/screens/saling_beli/saling_beli_page.dart';
import 'package:salink_mobile/screens/saling_pinjam/saling_pinjam_page.dart';
import 'package:salink_mobile/screens/saling_bagi/saling_bagi_page.dart';
import 'package:salink_mobile/screens/saling_tebeng/saling_tebeng_page.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: SaLinkColors.creamLight,
          title: const Text(
            'Konfirmasi Logout',
            style: TextStyle(
              color: SaLinkColors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari akun SaLink?',
            style: TextStyle(
              color: SaLinkColors.brown,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: SaLinkColors.brown,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SaLinkColors.orange,
                foregroundColor: SaLinkColors.creamLight,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !context.mounted) return;

    // Tutup drawer setelah pengguna mengonfirmasi logout.
    Navigator.pop(context);

    try {
      await AuthService().logout();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: SaLinkColors.creamLight,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // HEADER
          DrawerHeader(
            decoration: const BoxDecoration(
              color: SaLinkColors.brown,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'SaLink',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: SaLinkColors.yellow,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Platform Berbagi & Kolaborasi Kampus UI',
                  style: TextStyle(
                    fontSize: 13,
                    color: SaLinkColors.creamLight,
                  ),
                ),
              ],
            ),
          ),

          // HALAMAN UTAMA
          ListTile(
            leading: const Icon(
              Icons.home_outlined,
              color: SaLinkColors.brown,
            ),
            title: const Text(
              'Halaman Utama',
              style: TextStyle(
                color: SaLinkColors.brown,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ),
              );
            },
          ),

          // PROFIL SAYA
          ListTile(
            leading: const Icon(
              Icons.person_outline,
              color: SaLinkColors.brown,
            ),
            title: const Text(
              'Profil Saya',
              style: TextStyle(
                color: SaLinkColors.brown,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: SaLinkColors.brown,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),

          const Divider(
            color: SaLinkColors.cream,
            thickness: 1,
          ),

          // MODUL LAYANAN
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              'MODUL LAYANAN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: SaLinkColors.orange,
              ),
            ),
          ),

          _buildMenuItem(
            context,
            icon: Icons.shopping_bag_outlined,
            title: 'Saling Beli',
            subtitle: 'Preloved & Hibah',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SalingBeliPage(),
                ),
              );
            },
          ),

          _buildMenuItem(
            context,
            icon: Icons.handyman_outlined,
            title: 'Saling Pinjam',
            subtitle: 'Akses sementara barang perkuliahan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SalingPinjamPage(),
                ),
              );
            },
          ),

          _buildMenuItem(
            context,
            icon: Icons.fastfood_outlined,
            title: 'Saling Bagi',
            subtitle: 'Redistribusi makanan berlebih',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SalingBagiPage(),
                ),
              );
            },
          ),

          _buildMenuItem(
            context,
            icon: Icons.directions_car_outlined,
            title: 'Saling Tebeng',
            subtitle: 'Berbagi perjalanan ke kampus',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SalingTebengPage(),
                ),
              );
            },
          ),

          const Divider(
            color: SaLinkColors.cream,
            thickness: 1,
          ),

          // LOGOUT
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: SaLinkColors.orange,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: SaLinkColors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      child: Card(
        color: SaLinkColors.creamLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: SaLinkColors.yellow,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: SaLinkColors.orange,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: SaLinkColors.brown,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              color: SaLinkColors.orange,
              fontSize: 12,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: SaLinkColors.brown,
          ),
          onTap: () {
            Navigator.pop(context);
            onTap();
          },
        ),
      ),
    );
  }
}
