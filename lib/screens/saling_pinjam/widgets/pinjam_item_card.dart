import 'package:flutter/material.dart';
import 'package:salink_mobile/models/borrow_item.dart';
import 'package:salink_mobile/screens/saling_beli/saling_beli_theme.dart';

class PinjamItemCard extends StatelessWidget {
  final BorrowItem item;
  final VoidCallback? onTap;

  const PinjamItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  static const darkBrown = Color(0xFF4D2A00);
  static const primaryRust = Color(0xFFCC6F00);
  static const marigoldYellow = Color(0xFFF2A900);
  static const creamColor = Color(0xFFFFF6DC);

  @override
  Widget build(BuildContext context) {
    final num depositNum = num.tryParse(item.depositFee) ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: marigoldYellow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x224D2A00),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar Barang
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 1 / 0.85,
                child: Container(
                  color: const Color(0xFFEEEEEE),
                  child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                      ? Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Card Body (Krem)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: creamColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 13,
                            color: darkBrown,
                            height: 1.15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 12, color: primaryRust),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                item.pickupLocation,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF8C5A1F),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: darkBrown,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            depositNum > 0
                                ? 'JAMINAN ${formatRupiah(depositNum)}'
                                : 'TANPA JAMINAN',
                            style: const TextStyle(
                              fontFamily: 'Anton',
                              fontSize: 9,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Tombol Detail Pinjam
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRust,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        onPressed: onTap,
                        child: const Text(
                          'PINJAM',
                          style: TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF9E6A8),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.handyman_outlined, color: Color(0xFFCC6F00), size: 26),
            SizedBox(height: 2),
            Text(
              'SALINK PINJAM',
              style: TextStyle(
                fontFamily: 'Anton',
                fontSize: 9,
                color: Color(0xFF4D2A00),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
