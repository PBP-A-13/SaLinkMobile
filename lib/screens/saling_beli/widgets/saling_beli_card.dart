import 'package:flutter/material.dart';
import 'package:salink_mobile/models/item_listing.dart';
import 'package:salink_mobile/screens/saling_beli/saling_beli_theme.dart';

class SalingBeliCard extends StatelessWidget {
  final ItemListing item;
  final VoidCallback? onTap;
  final VoidCallback? onChatTap;

  const SalingBeliCard({
    super.key,
    required this.item,
    this.onTap,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF2A900); // marigold / yellow
    const creamColor = Color(0xFFFFF6DC); // krem dalam
    const darkBrown = Color(0xFF4D2A00); // cokelat tua
    const primaryRust = Color(0xFFCC6F00); // rust orange

    final num priceNum = num.tryParse(item.price) ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: accentColor,
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
                aspectRatio: 1 / 0.88,
                child: Container(
                  color: const Color(0xFFEEEEEE),
                  child: item.displayImage != null && item.displayImage!.isNotEmpty
                      ? Image.network(
                          item.displayImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Card Body (krem)
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: creamColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title & Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 14,
                            letterSpacing: 0.2,
                            color: darkBrown,
                            height: 1.15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (item.isFree)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: darkBrown,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              '🎁 GRATIS',
                              style: TextStyle(
                                fontFamily: 'Anton',
                                fontSize: 11,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          )
                        else
                          Text(
                            formatRupiah(priceNum),
                            style: const TextStyle(
                              fontFamily: 'Anton',
                              fontSize: 14,
                              color: primaryRust,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),

                    // Actions Row
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryRust,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                                onPressed: onTap,
                                child: const Text(
                                  'DETAIL',
                                  style: TextStyle(
                                    fontFamily: 'Anton',
                                    fontSize: 11,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: creamColor,
                                side: const BorderSide(color: darkBrown, width: 1.5),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              onPressed: onChatTap ?? onTap,
                              icon: const Icon(
                                Icons.chat_bubble_outline,
                                size: 15,
                                color: darkBrown,
                              ),
                              tooltip: 'Chat Penjual',
                            ),
                          ),
                        ],
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
            Icon(Icons.shopping_bag_outlined, color: Color(0xFFCC6F00), size: 28),
            SizedBox(height: 2),
            Text(
              'TANPA FOTO',
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
