import 'package:flutter/material.dart';

class FilterPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FilterPill({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const darkBrown = Color(0xFF4D2A00);
    const creamColor = Color(0xFFFFF6DC);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? darkBrown : creamColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: darkBrown,
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  const BoxShadow(
                    color: Color(0x334D2A00),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Anton',
            fontSize: 12,
            letterSpacing: 0.3,
            color: isActive ? Colors.white : darkBrown,
          ),
        ),
      ),
    );
  }
}
