import 'package:flutter/material.dart';

class PinjamCalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const PinjamCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const darkBrown = Color(0xFF4D2A00);
  static const primaryRust = Color(0xFFCC6F00);
  static const accentYellow = Color(0xFFF2A900);
  static const creamCell = Color(0xFFFFF6DC);

  static const List<String> _days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

  static const List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  Widget build(BuildContext context) {
    final year = selectedDate.year;
    final month = selectedDate.month;

    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7D9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBrown, width: 2),
        boxShadow: const [
          BoxShadow(
            color: darkBrown,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Navigasi Bulan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: creamCell,
                  side: const BorderSide(color: darkBrown, width: 1.5),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.chevron_left, color: darkBrown),
                onPressed: () {
                  final prev = DateTime(year, month - 1, 1);
                  onDateSelected(prev);
                },
              ),
              Text(
                'JADWAL PINJAM · ${_months[month - 1].toUpperCase()} $year',
                style: const TextStyle(
                  fontFamily: 'Anton',
                  fontSize: 16,
                  color: darkBrown,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: creamCell,
                  side: const BorderSide(color: darkBrown, width: 1.5),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.chevron_right, color: darkBrown),
                onPressed: () {
                  final next = DateTime(year, month + 1, 1);
                  onDateSelected(next);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Nama-nama Hari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _days
                .map((d) => SizedBox(
                      width: 36,
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 12,
                          color: primaryRust,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Grid Tanggal
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 35, // 5 minggu
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - startingWeekday + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return Container(
                  decoration: BoxDecoration(
                    color: creamCell.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }

              final cellDate = DateTime(year, month, dayNumber);
              final isPast = cellDate.isBefore(today);
              final isSelected = cellDate.year == selectedDate.year &&
                  cellDate.month == selectedDate.month &&
                  cellDate.day == selectedDate.day;
              final isToday = cellDate.year == today.year &&
                  cellDate.month == today.month &&
                  cellDate.day == today.day;

              return InkWell(
                onTap: isPast ? null : () => onDateSelected(cellDate),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentYellow
                        : (isPast ? creamCell.withValues(alpha: 0.4) : creamCell),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isToday
                          ? primaryRust
                          : (isSelected ? darkBrown : Colors.transparent),
                      width: isToday || isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? const [
                            BoxShadow(
                              color: darkBrown,
                              offset: Offset(2, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNumber',
                      style: TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 13,
                        color: isPast
                            ? const Color(0xFF8C5A1F).withValues(alpha: 0.5)
                            : darkBrown,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
