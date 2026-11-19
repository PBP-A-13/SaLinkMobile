import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/salink_colors.dart';
import '../../widgets/left_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _authService.getProfile();
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = _authService.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6DC),

      // APP BAR
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontFamily: 'Anton',
            color: SaLinkColors.yellow,
            fontSize: 24,
          ),
        ),
        backgroundColor: SaLinkColors.brown,
        foregroundColor: SaLinkColors.yellow,
        elevation: 0,
      ),

      // LEFT DRAWER
      drawer: const LeftDrawer(),

      // PROFILE CONTENT
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: SaLinkColors.orange,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: SaLinkColors.orange,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal mengambil profil:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: SaLinkColors.brown,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SaLinkColors.brown,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Data profil tidak tersedia.',
                style: TextStyle(color: SaLinkColors.brown),
              ),
            );
          }

          final profile = snapshot.data!;

          final username = profile['username'] ?? '-';
          final email = profile['email'] ?? '-';
          final firstName = profile['first_name'] ?? '';
          final lastName = profile['last_name'] ?? '';

          final fullName = '$firstName $lastName'.trim();

          return RefreshIndicator(
            color: SaLinkColors.orange,
            backgroundColor: const Color(0xFFFFF6DC),
            onRefresh: () async {
              _refreshProfile();
              await _profileFuture;
            },

            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 24),

                // PROFILE AVATAR
                const Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: SaLinkColors.yellow,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: SaLinkColors.brown,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // FULL NAME
                Center(
                  child: Text(
                    fullName.isEmpty ? username : fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 24,
                      color: SaLinkColors.brown,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // USERNAME
                Center(
                  child: Text(
                    '@$username',
                    style: const TextStyle(
                      color: SaLinkColors.orange,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Divider(
                  color: SaLinkColors.brown.withValues(alpha: 0.25),
                  thickness: 1,
                ),

                const SizedBox(height: 12),

                // USERNAME INFORMATION
                _ProfileInfoTile(
                  icon: Icons.person_outline,
                  title: 'Username',
                  value: username,
                ),

                // EMAIL INFORMATION
                _ProfileInfoTile(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  value: email,
                ),

                // FULL NAME INFORMATION
                _ProfileInfoTile(
                  icon: Icons.badge_outlined,
                  title: 'Nama Lengkap',
                  value: fullName.isEmpty ? '-' : fullName,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// PROFILE INFORMATION WIDGET
class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      leading: Icon(
        icon,
        color: SaLinkColors.orange,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: SaLinkColors.brown,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          color: SaLinkColors.orange,
          fontSize: 14,
        ),
      ),
    );
  }
}
