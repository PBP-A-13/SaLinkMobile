import 'package:flutter/material.dart';
import 'package:salink_mobile/models/borrow_item.dart';
import 'package:salink_mobile/screens/saling_pinjam/widgets/pinjam_calendar_widget.dart';
import 'package:salink_mobile/screens/saling_pinjam/widgets/pinjam_item_card.dart';
import 'package:salink_mobile/widgets/left_drawer.dart';

class SalingPinjamPage extends StatefulWidget {
  const SalingPinjamPage({super.key});

  @override
  State<SalingPinjamPage> createState() => _SalingPinjamPageState();
}

class _SalingPinjamPageState extends State<SalingPinjamPage> {
  static const darkBrown = Color(0xFF4D2A00);
  static const primaryRust = Color(0xFFCC6F00);
  static const marigoldYellow = Color(0xFFF2A900);
  static const butterBg = Color(0xFFF9E6A8);
  static const creamInput = Color(0xFFFFF6DC);

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = '';

  // Mock data barang pinjaman
  late final List<BorrowItem> _mockBorrowItems = [
    const BorrowItem(
      id: 'p1',
      name: 'Jas Lab Kimia Fasilkom Size L',
      description: 'Jas lab bersih, kancing lengkap, siap pakai untuk praktikum dasar.',
      category: 'ACADEMIC',
      condition: 'LIKE_NEW',
      maxDurationDays: 3,
      depositFee: '20000',
      pickupLocation: 'Gedung Lama Fasilkom UI',
      imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&q=80',
      status: 'AVAILABLE',
      ownerUsername: 'hasbi_cs',
    ),
    const BorrowItem(
      id: 'p2',
      name: 'Kalkulator Saintifik Casio fx-991EX',
      description: 'Kalkulator canggih untuk kalkulus, aljabar linear, dan statistika.',
      category: 'ELECTRONICS',
      condition: 'GOOD',
      maxDurationDays: 7,
      depositFee: '50000',
      pickupLocation: 'Perpustakaan Pusat UI',
      imageUrl: 'https://images.unsplash.com/photo-1611125832047-1d7ad1e8e4cb?w=500&q=80',
      status: 'AVAILABLE',
      ownerUsername: 'balqis_r',
    ),
    const BorrowItem(
      id: 'p3',
      name: 'Toga Wisuda Sarjana UI + Topi',
      description: 'Dipinjamkan untuk foto wisuda atau yudisium dadakan.',
      category: 'ACADEMIC',
      condition: 'LIKE_NEW',
      maxDurationDays: 2,
      depositFee: '100000',
      pickupLocation: 'Balairung UI',
      imageUrl: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=500&q=80',
      status: 'AVAILABLE',
      ownerUsername: 'alief_m',
    ),
    const BorrowItem(
      id: 'p4',
      name: 'Toolkit Obeng & Kunci Pas Kosan',
      description: 'Perkakas lengkap 24-in-1 untuk bongkar pasang lemari kos.',
      category: 'TOOLS',
      condition: 'GOOD',
      maxDurationDays: 5,
      depositFee: '0',
      pickupLocation: 'Kutek Depok',
      imageUrl: 'https://images.unsplash.com/photo-1581783342308-f792dbdd27c5?w=500&q=80',
      status: 'AVAILABLE',
      ownerUsername: 'fahmi_f',
    ),
    const BorrowItem(
      id: 'p5',
      name: 'Carrier Deuter 60L Gunung',
      description: 'Tas gunung kuat dan bersih untuk kegiatan ormawa atau naik gunung.',
      category: 'TRAVEL',
      condition: 'GOOD',
      maxDurationDays: 4,
      depositFee: '75000',
      pickupLocation: 'Stasiun Pondok Cina',
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&q=80',
      status: 'AVAILABLE',
      ownerUsername: 'budi_ui',
    ),
  ];

  // Mock slot pinjaman saya yang sedang aktif
  late final List<ActiveBorrowSlot> _activeSlots = [
    ActiveBorrowSlot(
      id: 's1',
      itemName: 'Kalkulator Saintifik Casio fx-991EX',
      pickupLocation: 'Perpustakaan Pusat UI',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 3)),
      status: 'APPROVED',
      imageUrl: 'https://images.unsplash.com/photo-1611125832047-1d7ad1e8e4cb?w=500&q=80',
    ),
  ];

  final List<Map<String, String>> _categories = [
    {'value': '', 'label': 'Semua Kategori'},
    {'value': 'ACADEMIC', 'label': 'Akademik & Formal'},
    {'value': 'ELECTRONICS', 'label': 'Elektronik & Aksesori'},
    {'value': 'TOOLS', 'label': 'Peralatan & Hobi'},
    {'value': 'TRAVEL', 'label': 'Travel & Koper'},
  ];

  List<BorrowItem> get _filteredItems {
    if (_selectedCategory.isEmpty) return _mockBorrowItems;
    return _mockBorrowItems
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: butterBg,
      appBar: AppBar(
        backgroundColor: darkBrown,
        foregroundColor: marigoldYellow,
        elevation: 0,
        title: const Text(
          'SaLink - Pinjam',
          style: TextStyle(
            fontFamily: 'Anton',
            fontSize: 24,
            color: marigoldYellow,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined, color: marigoldYellow),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Riwayat peminjaman barang kamu'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Riwayat Pinjaman',
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section Title: Hari Ini & Tombol Tawaran ──────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HARI INI, ${_formatDateHeader(DateTime.now())}',
                      style: const TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 18,
                        color: darkBrown,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Text(
                      'Pinjam & pinjamkan barang perkuliahan UI',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8C5A1F)),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: marigoldYellow,
                    foregroundColor: darkBrown,
                    side: const BorderSide(color: darkBrown, width: 2),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Form Pinjamkan Barang akan segera hadir!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 16, color: darkBrown),
                  label: const Text(
                    '+ PINJAMKAN',
                    style: TextStyle(fontFamily: 'Anton', fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Kalender Jadwal Peminjaman ─────────────────────────
            PinjamCalendarWidget(
              selectedDate: _selectedDate,
              onDateSelected: (newDate) {
                setState(() => _selectedDate = newDate);
              },
            ),
            const SizedBox(height: 24),

            // ── Section: Pinjaman Saya (Active Slots) ──────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: creamInput,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: darkBrown, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: darkBrown,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PINJAMAN AKTIF SAYA',
                        style: TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 15,
                          color: darkBrown,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: darkBrown,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${_activeSlots.length}/3 Slot Digunakan',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_activeSlots.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Belum ada pinjaman aktif. Pilih barang di bawah untuk meminjam.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF8C5A1F)),
                      ),
                    )
                  else
                    ..._activeSlots.map((slot) => _buildActiveSlotCard(slot)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Filter Kategori Barang ─────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((c) {
                  final isSelected = _selectedCategory == c['value'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _selectedCategory = c['value']!),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? darkBrown : creamInput,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: darkBrown, width: 1.5),
                        ),
                        child: Text(
                          c['label']!,
                          style: TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 12,
                            color: isSelected ? Colors.white : darkBrown,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // ── Section Barang Bebas Dipinjam ──────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BARANG TERSEDIA (${items.length})',
                  style: const TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 16,
                    color: darkBrown,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Bebas per ${_selectedDate.day}/${_selectedDate.month}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: primaryRust,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Grid Barang Pinjaman ───────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return PinjamItemCard(
                  item: item,
                  onTap: () => _showBorrowDialog(context, item),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSlotCard(ActiveBorrowSlot slot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: darkBrown, width: 1.5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 48,
              height: 48,
              color: butterBg,
              child: slot.imageUrl != null
                  ? Image.network(slot.imageUrl!, fit: BoxFit.cover)
                  : const Icon(Icons.handyman_outlined, color: darkBrown),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.itemName.toUpperCase(),
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
                  '${slot.startDate.day}/${slot.startDate.month} - ${slot.endDate.day}/${slot.endDate.month} · ${slot.pickupLocation}',
                  style: const TextStyle(fontSize: 10, color: Color(0xFF8C5A1F)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4F0D4),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF2F5A12), width: 1),
                  ),
                  child: Text(
                    slot.statusDisplay,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F5A12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBorrowDialog(BuildContext context, BorrowItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: creamInput,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: darkBrown, width: 3)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: darkBrown.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.name.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Anton',
                fontSize: 20,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${item.categoryDisplay} · Milik @${item.ownerUsername}',
              style: const TextStyle(fontSize: 12, color: primaryRust, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              item.description,
              style: const TextStyle(fontSize: 13, color: darkBrown, height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: primaryRust),
                const SizedBox(width: 4),
                Text(
                  'Maksimal Pinjam ${item.maxDurationDays} Hari',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: darkBrown),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: primaryRust),
                const SizedBox(width: 4),
                Text(
                  item.pickupLocation,
                  style: const TextStyle(fontSize: 12, color: darkBrown),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRust,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Pengajuan pinjam untuk ${item.name} berhasil dibuat!'),
                        ),
                      );
                    },
                    child: const Text('AJUKAN PINJAMAN', style: TextStyle(fontFamily: 'Anton')),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: darkBrown, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('TUTUP', style: TextStyle(fontFamily: 'Anton', color: darkBrown)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1].toUpperCase()} ${date.year}';
  }
}
