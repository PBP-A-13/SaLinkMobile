
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/salink_colors.dart';
import '../menu.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  final TextEditingController _usernameController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username dan password wajib diisi.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.login(username, password);

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      } else {
        final data = result['data'];
        final message = data['error'] ??
            'Login gagal. Periksa kembali data kamu.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.toString())),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Anton',
            fontSize: 14,
            color: SaLinkColors.brown,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 15,
            color: SaLinkColors.brown,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              color: SaLinkColors.brown.withOpacity(0.5),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: SaLinkColors.brown,
              size: 20,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: SaLinkColors.brown,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: SaLinkColors.orange,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaLinkColors.cream,
      appBar: AppBar(
        backgroundColor: SaLinkColors.brown,
        foregroundColor: SaLinkColors.yellow,
        elevation: 0,
        title: const Text(
          'SaLink',
          style: TextStyle(
            fontFamily: 'Anton',
            fontSize: 25,
            color: SaLinkColors.yellow,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: SaLinkColors.creamLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: SaLinkColors.brown,
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: SaLinkColors.brown,
                        offset: Offset(7, 8),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SELAMAT DATANG KEMBALI',
                        style: TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 13,
                          color: SaLinkColors.orange,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Masuk ke SaLink',
                        style: TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 30,
                          color: SaLinkColors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gunakan akunmu untuk lanjut ke SaLink.',
                        style: TextStyle(
                          fontSize: 15,
                          color: SaLinkColors.orange,
                        ),
                      ),
                      const SizedBox(height: 28),

                      _buildInput(
                        label: 'Username',
                        controller: _usernameController,
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),

                      _buildInput(
                        label: 'Password',
                        controller: _passwordController,
                        icon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: SaLinkColors.brown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SaLinkColors.brown,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                SaLinkColors.brown.withOpacity(0.6),
                            padding: const EdgeInsets.symmetric(
                              vertical: 17,
                              horizontal: 20,
                            ),
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'MASUK',
                                      style: TextStyle(
                                        fontFamily: 'Anton',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            const Text(
                              'Belum punya akun? ',
                              style: TextStyle(
                                color: SaLinkColors.orange,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Daftar sekarang',
                                style: TextStyle(
                                  color: SaLinkColors.orange,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: SaLinkColors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

