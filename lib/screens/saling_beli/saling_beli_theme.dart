import 'package:flutter/material.dart';

/// Ekstensi warna dan style SaLink sesuai tema web SaLink
extension SaLinkThemeExtension on BuildContext {
  Color get salinkBrown => const Color(0xFF4D2A00);
  Color get salinkOrange => const Color(0xFFCC6F00);
  Color get salinkYellow => const Color(0xFFF2A900);
  Color get salinkButter => const Color(0xFFF9E6A8);
  Color get salinkCream => const Color(0xFFFFF6DC);
  Color get salinkMuted => const Color(0xFF8C5A1F);
}

/// Helper format Rupiah tanpa ketergantungan intl package
String formatRupiah(num amount) {
  final str = amount.toInt().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(str[i]);
  }
  return 'Rp${buffer.toString()}';
}
