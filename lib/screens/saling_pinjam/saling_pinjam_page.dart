import 'package:flutter/material.dart';
import 'package:salink_mobile/models/borrow_item.dart';
import 'package:salink_mobile/screens/saling_pinjam/widgets/pinjam_calendar_widget.dart';
import 'package:salink_mobile/screens/saling_pinjam/widgets/pinjam_item_card.dart';
import 'package:salink_mobile/services/saling_pinjam_service.dart';
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

  final SalingPinjamService _pinjamService = SalingPinjamService();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = '';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<BorrowItem> _items = [
    const BorrowItem(
      id: 'mock-1',
      name: 'Jas Lab Kimia Fasilkom Size L',
      description: 'Jas lab bersih, kancing lengkap, siap pakai untuk praktikum dasar.',
      category: 'ACADEMIC',
      condition: 'LIKE_NEW',
      maxDurationDays: 3,
      depositFee: '20000',
      pickupLocation: 'Gedung Lama Fasilkom UI',
      status: 'AVAILABLE',
      ownerUsername: 'hasbi_cs',
    ),
  ];
  List<ActiveBorrowSlot> _asBorrower = [];
  List<ActiveBorrowSlot> _asOwner = [];
  bool _isLoading = false;

  final List<Map<String, String>> _categories = [
    {'value': '', 'label': 'Semua Kategori'},
    {'value': 'ACADEMIC', 'label': 'Akademik & Formal'},
    {'value': 'ELECTRONICS', 'label': 'Elektronik & Aksesori'},
    {'value': 'TOOLS', 'label': 'Peralatan & Hobi'},
    {'value': 'TRAVEL', 'label': 'Travel & Koper'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final items = await _pinjamService.fetchItems(
        query: _searchQuery,
        category: _selectedCategory,
      );
      Map<String, dynamic> myBorrows = {};
      try {
        myBorrows = await _pinjamService.fetchMyBorrows();
      } catch (_) {
        // Fallback jika belum login
      }

      if (mounted) {
        setState(() {
          _items = items;
          _asBorrower = (myBorrows['as_borrower'] as List<ActiveBorrowSlot>?) ?? [];
          _asOwner = (myBorrows['as_owner'] as List<ActiveBorrowSlot>?) ?? [];
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Riwayat & Konfirmasi',
            onPressed: () => _showMyBorrowsSheet(context),
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: RefreshIndicator(
        color: primaryRust,
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Badge & Titik Temu
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: creamInput,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: darkBrown, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.handyman, color: primaryRust, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SALING PINJAM UI',
                            style: TextStyle(
                              fontFamily: 'Anton',
                              fontSize: 15,
                              color: darkBrown,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Peminjaman peralatan & perlengkapan kampus terverifikasi dua arah.',
                            style: TextStyle(
                              fontSize: 11,
                              color: darkBrown.withValues(alpha: 0.8),
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Search Bar
              TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13, color: darkBrown),
                decoration: InputDecoration(
                  hintText: 'Cari jas lab, kalkulator, carrier...',
                  hintStyle: TextStyle(fontSize: 12, color: darkBrown.withValues(alpha: 0.5)),
                  prefixIcon: const Icon(Icons.search, size: 20, color: primaryRust),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                            _loadData();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: creamInput,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: const BorderSide(color: darkBrown, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: const BorderSide(color: darkBrown, width: 2),
                  ),
                ),
                onSubmitted: (val) {
                  setState(() => _searchQuery = val.trim());
                  _loadData();
                },
              ),

              const SizedBox(height: 12),

              // Category Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat['value'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          cat['label']!,
                          style: TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 11,
                            letterSpacing: 0.5,
                            color: isSelected ? Colors.white : darkBrown,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: primaryRust,
                        backgroundColor: creamInput,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: const BorderSide(color: darkBrown, width: 1.5),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? cat['value']! : '';
                          });
                          _loadData();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 14),

              // Slot Pinjaman Saya yang Sedang Aktif
              if (_asBorrower.isNotEmpty || _asOwner.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'STATUS SERAH-TERIMA DUA ARAH',
                      style: TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 14,
                        color: darkBrown,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showMyBorrowsSheet(context),
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryRust,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ..._asBorrower.take(2).map((slot) => _buildTwoWaySlotCard(slot, isOwner: false)),
                ..._asOwner.take(2).map((slot) => _buildTwoWaySlotCard(slot, isOwner: true)),
                const SizedBox(height: 14),
              ],

              // Kalender Peminjaman
              PinjamCalendarWidget(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Section Barang Siap Pinjam
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BARANG TERSEDIA (${_items.length})',
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 15,
                      color: darkBrown,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    _formatDateHeader(_selectedDate),
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 12,
                      color: primaryRust,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Grid Katalog Barang
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: primaryRust),
                  ),
                )
              else if (_items.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: creamInput,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: darkBrown, width: 2),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 40, color: primaryRust),
                        SizedBox(height: 8),
                        Text(
                          'Belum Ada Barang Pinjaman',
                          style: TextStyle(fontFamily: 'Anton', fontSize: 14, color: darkBrown),
                        ),
                      ],
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (ctx, index) {
                    final item = _items[index];
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
      ),
    );
  }

  Widget _buildTwoWaySlotCard(ActiveBorrowSlot slot, {required bool isOwner}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: creamInput,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: darkBrown, width: 1.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isOwner ? primaryRust : marigoldYellow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isOwner ? 'BARANG SAYA DIPINJAM' : 'SAYA MEMINJAM',
                  style: const TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 9,
                    color: darkBrown,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                slot.statusDisplay,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: primaryRust,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            slot.item.name,
            style: const TextStyle(
              fontFamily: 'Anton',
              fontSize: 14,
              color: darkBrown,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Titik Temu: ${slot.item.pickupLocation}',
            style: const TextStyle(fontSize: 11, color: darkBrown),
          ),
          if (slot.handoverStatusDisplay.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              slot.handoverStatusDisplay,
              style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: primaryRust),
            ),
          ],
          if (slot.returnStatusDisplay.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              slot.returnStatusDisplay,
              style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: primaryRust),
            ),
          ],
          if (slot.canConfirmHandover || slot.canConfirmReturn) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBrown,
                  foregroundColor: marigoldYellow,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                onPressed: () => _handleTwoWayAction(slot),
                child: Text(
                  slot.canConfirmHandover
                      ? (isOwner ? 'KONFIRMASI SERAHKAN BARANG' : 'KONFIRMASI TERIMA BARANG')
                      : (isOwner ? 'KONFIRMASI TERIMA KEMBALI' : 'KONFIRMASI KEMBALIKAN BARANG'),
                  style: const TextStyle(fontFamily: 'Anton', fontSize: 11),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleTwoWayAction(ActiveBorrowSlot slot) async {
    if (slot.canConfirmHandover) {
      final res = await _pinjamService.confirmHandover(slot.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Konfirmasi serah-terima dicatat.')),
        );
        _loadData();
      }
    } else if (slot.canConfirmReturn) {
      final res = await _pinjamService.confirmReturn(slot.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Konfirmasi pengembalian dicatat.')),
        );
        _loadData();
      }
    }
  }

  void _showMyBorrowsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: butterBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: darkBrown, width: 3)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
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
            const SizedBox(height: 12),
            const Text(
              'DAFTAR PINJAMAN DUA ARAH',
              style: TextStyle(fontFamily: 'Anton', fontSize: 18, color: darkBrown),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: darkBrown,
                      indicatorColor: primaryRust,
                      labelStyle: const TextStyle(fontFamily: 'Anton', fontSize: 12),
                      tabs: [
                        Tab(text: 'Saya Pinjam (${_asBorrower.length})'),
                        Tab(text: 'Barang Saya Dipinjam (${_asOwner.length})'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _asBorrower.isEmpty
                              ? const Center(child: Text('Belum ada pinjaman diajukan.'))
                              : ListView.builder(
                                  itemCount: _asBorrower.length,
                                  itemBuilder: (c, i) => _buildTwoWaySlotCard(_asBorrower[i], isOwner: false),
                                ),
                          _asOwner.isEmpty
                              ? const Center(child: Text('Belum ada pengajuan masuk.'))
                              : ListView.builder(
                                  itemCount: _asOwner.length,
                                  itemBuilder: (c, i) => _buildTwoWaySlotCard(_asOwner[i], isOwner: true),
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

  void _showBorrowDialog(BuildContext context, BorrowItem item) {
    DateTime reqStart = DateTime.now();
    DateTime reqEnd = DateTime.now().add(Duration(days: item.maxDurationDays > 1 ? 2 : 1));
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: creamInput,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: darkBrown, width: 3)),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            24 + MediaQuery.of(ctx).viewInsets.bottom,
          ),
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
                  Expanded(
                    child: Text(
                      item.pickupLocation,
                      style: const TextStyle(fontSize: 12, color: darkBrown),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Pesan / Keperluan Pinjam',
                  hintText: 'Contoh: Untuk praktikum lab hari Kamis',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
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
                      onPressed: () async {
                        Navigator.pop(ctx);
                        final messenger = ScaffoldMessenger.of(context);
                        final res = await _pinjamService.requestBorrow(
                          itemId: item.id,
                          startDate: reqStart,
                          endDate: reqEnd,
                          notes: notesController.text.trim(),
                        );
                        if (mounted) {
                          messenger.showSnackBar(
                            SnackBar(content: Text(res['message'] ?? 'Pengajuan berhasil!')),
                          );
                          _loadData();
                        }
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
