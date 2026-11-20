import 'package:flutter/material.dart';
import 'package:salink_mobile/models/item_listing.dart';
import 'package:salink_mobile/screens/saling_beli/saling_beli_theme.dart';

class MiniItemCard extends StatelessWidget {
  final ItemListing item;
  final VoidCallback? onTap;

  const MiniItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const darkBrown = Color(0xFF4D2A00);
    const primaryRust = Color(0xFFCC6F00);

    final num priceNum = num.tryParse(item.price) ?? 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 175,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: darkBrown, width: 2),
          boxShadow: const [
            BoxShadow(
              color: darkBrown,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9E6A8),
                  border: Border.all(color: darkBrown, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: item.displayImage != null && item.displayImage!.isNotEmpty
                    ? Image.network(
                        item.displayImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) =>
                            const Icon(Icons.image_not_supported, size: 20, color: darkBrown),
                      )
                    : const Icon(Icons.shopping_bag_outlined, size: 20, color: darkBrown),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 12,
                      color: darkBrown,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.isFree ? 'Gratis' : formatRupiah(priceNum),
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 11,
                      color: item.isFree ? darkBrown : primaryRust,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
