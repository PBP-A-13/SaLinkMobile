import 'package:flutter/material.dart';
import 'package:salink_mobile/models/item_listing.dart';
import 'package:salink_mobile/screens/saling_beli/widgets/saling_beli_card.dart';
import 'package:salink_mobile/screens/saling_beli/widgets/filter_pill.dart';
import 'package:salink_mobile/screens/saling_beli/widgets/mini_item_card.dart';
import 'package:salink_mobile/widgets/left_drawer.dart';

class SalingBeliPage extends StatefulWidget {
  const SalingBeliPage({super.key});

  @override
  State<SalingBeliPage> createState() => _SalingBeliPageState();
}

class _SalingBeliPageState extends State<SalingBeliPage> {
  // Palet Warna SaLink (sesuai Figma & CSS Web SaLink)
  static const darkBrown = Color(0xFF4D2A00);
  static const primaryRust = Color(0xFFCC6F00);
  static const marigoldYellow = Color(0xFFF2A900);
  static const butterBg = Color(0xFFF9E6A8);
  static const creamInput = Color(0xFFFFF6DC);

  final TextEditingController _searchController = TextEditingController();

  // State Filter & Urutan
  String _selectedSort = 'newest';
  String _selectedCategory = '';
  String _selectedCondition = '';
  String _searchQuery = '';

  // Data kategori & kondisi sesuai models.py Django
  final List<Map<String, String>> _sortOptions = [
    {'value': 'newest', 'label': 'Terbaru'},
    {'value': 'oldest', 'label': 'Paling Lama'},
    {'value': 'name_asc', 'label': 'Nama A - Z'},
    {'value': 'name_desc', 'label': 'Nama Z - A'},
  ];

  final List<Map<String, String>> _categories = [
    {'value': '', 'label': 'Semua'},
    {'value': 'FURNITURE', 'label': 'Furnitur & Kos'},
    {'value': 'ELECTRONICS', 'label': 'Elektronik & Gadget'},
    {'value': 'BOOKS', 'label': 'Buku & Tulis'},
    {'value': 'CLOTHING', 'label': 'Pakaian'},
    {'value': 'KITCHEN', 'label': 'Dapur'},
    {'value': 'OTHER', 'label': 'Lain-lain'},
  ];

  final List<Map<String, String>> _conditions = [
    {'value': '', 'label': 'Semua'},
    {'value': 'BRAND_NEW', 'label': 'Baru'},
    {'value': 'LIKE_NEW', 'label': 'Seperti Baru'},
    {'value': 'GOOD', 'label': 'Layak Pakai'},
    {'value': 'FAIR', 'label': 'Ada Minus'},
  ];

  // Dummy mock data untuk preview UI tanpa harus tergantung koneksi internet / server lokal
  late final List<ItemListing> _mockItems = [
    ItemListing(
      id: '1',
      title: 'Meja Belajar Lipat Minimalis Kayu',
      description: 'Meja lipat kokoh cocok untuk kosan dekat Pocin, masih mulus.',
      category: 'FURNITURE',
      condition: 'LIKE_NEW',
      isFree: false,
      price: '85000',
      displayImage: 'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=500&q=80',
      pickupLocation: 'Kutek UI',
      status: 'AVAILABLE',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now(),
    ),
    ItemListing(
      id: '2',
      title: 'Buku Kalkulus Purcell Edisi 9',
      description: 'Dihibahkan gratis untuk adik tingkat Fasilkom yang butuh.',
      category: 'BOOKS',
      condition: 'GOOD',
      isFree: true,
      price: '0',
      displayImage: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500&q=80',
      pickupLocation: 'Perpustakaan Pusat UI',
      status: 'AVAILABLE',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now(),
    ),
    ItemListing(
      id: '3',
      title: 'Kipas Angin Meja Miyako 9 Inch',
      description: 'Angin kencang, tidak berisik, kabel aman lengkap.',
      category: 'ELECTRONICS',
      condition: 'GOOD',
      isFree: false,
      price: '60000',
      displayImage: 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=500&q=80',
      pickupLocation: 'Kober UI',
      status: 'AVAILABLE',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
    ),
    ItemListing(
      id: '4',
      title: 'Hoodie UI Makara Kuning Size L',
      description: 'Original merchandise UI, jarang dipakai masih sangat bagus.',
      category: 'CLOTHING',
      condition: 'LIKE_NEW',
      isFree: false,
      price: '120000',
      displayImage: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=500&q=80',
      pickupLocation: 'Fasilkom UI',
      status: 'AVAILABLE',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    ),
    ItemListing(
      id: '5',
      title: 'Panci Listrik Serbaguna 1.5L',
      description: 'Bisa untuk masak mie, rebus telur, cocok anak kos.',
      category: 'KITCHEN',
      condition: 'BRAND_NEW',
      isFree: false,
      price: '45000',
      displayImage: null,
      pickupLocation: 'Pocin Depok',
      status: 'AVAILABLE',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now(),
    ),
    ItemListing(
      id: '6',
      title: 'Rak Sepatu Susun 4 Plastik',
      description: 'Hibah gratis karena mau lulus wisuda dan pindahan kos.',
      category: 'FURNITURE',
      condition: 'GOOD',
      isFree: true,
      price: '0',
      displayImage: null,
      pickupLocation: 'Kukel UI',
      status: 'AVAILABLE',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ItemListing> get _filteredItems {
    return _mockItems.where((item) {
      // Filter Search
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(query);
        final matchDesc = item.description.toLowerCase().contains(query);
        if (!matchTitle && !matchDesc) return false;
      }
      // Filter Category
      if (_selectedCategory.isNotEmpty && item.category != _selectedCategory) {
        return false;
      }
      // Filter Condition
      if (_selectedCondition.isNotEmpty && item.condition != _selectedCondition) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        if (_selectedSort == 'newest') {
          return b.createdAt.compareTo(a.createdAt);
        } else if (_selectedSort == 'oldest') {
          return a.createdAt.compareTo(b.createdAt);
        } else if (_selectedSort == 'name_asc') {
          return a.title.compareTo(b.title);
        } else if (_selectedSort == 'name_desc') {
          return b.title.compareTo(a.title);
        }
        return 0;
      });
  }

  void _resetFilters() {
    setState(() {
      _selectedSort = 'newest';
      _selectedCategory = '';
      _selectedCondition = '';
      _searchQuery = '';
      _searchController.clear();
    });
  }

  bool get _hasActiveFilter =>
      _searchQuery.isNotEmpty ||
      _selectedCategory.isNotEmpty ||
      _selectedCondition.isNotEmpty ||
      _selectedSort != 'newest';

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    final savedItems = _mockItems.where((i) => i.isFree).toList();
    final recentlyViewed = _mockItems.take(2).toList();

    return Scaffold(
      backgroundColor: butterBg,
      appBar: AppBar(
        backgroundColor: darkBrown,
        foregroundColor: marigoldYellow,
        elevation: 0,
        title: const Text(
          'SaLink - Beli',
          style: TextStyle(
            fontFamily: 'Anton',
            fontSize: 24,
            color: marigoldYellow,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: marigoldYellow),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur Barang Tersimpan (Bookmark)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Barang Tersimpan',
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Search & CTA Jual Bar ──────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: creamInput,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: darkBrown, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: darkBrown, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Cari Barang Prelove UI...',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF8C5A1F),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              color: darkBrown,
                              fontWeight: FontWeight.w500,
                            ),
                            onChanged: (val) {
                              setState(() => _searchQuery = val.trim());
                            },
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            child: const Icon(Icons.clear, size: 18, color: darkBrown),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRust,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Halaman Tambah Barang akan segera hadir!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text(
                    'JUAL',
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Filter Bar (Pills & Sorting) ────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: creamInput,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: darkBrown.withValues(alpha: 0.3), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row Urutkan
                  _buildFilterRow(
                    label: 'URUTKAN',
                    children: _sortOptions.map((opt) {
                      return FilterPill(
                        label: opt['label']!,
                        isActive: _selectedSort == opt['value'],
                        onTap: () => setState(() => _selectedSort = opt['value']!),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // Row Kategori
                  _buildFilterRow(
                    label: 'KATEGORI',
                    children: _categories.map((cat) {
                      return FilterPill(
                        label: cat['label']!,
                        isActive: _selectedCategory == cat['value'],
                        onTap: () => setState(() => _selectedCategory = cat['value']!),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // Row Kondisi
                  _buildFilterRow(
                    label: 'KONDISI',
                    children: [
                      ..._conditions.map((cond) {
                        return FilterPill(
                          label: cond['label']!,
                          isActive: _selectedCondition == cond['value'],
                          onTap: () => setState(() => _selectedCondition = cond['value']!),
                        );
                      }),
                      if (_hasActiveFilter)
                        InkWell(
                          onTap: _resetFilters,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD32F2F),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'RESET FILTER',
                              style: TextStyle(
                                fontFamily: 'Anton',
                                fontSize: 11,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Header Hasil & Jumlah Barang ────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'KATALOG BARANG (${items.length})',
                  style: const TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 16,
                    color: darkBrown,
                    letterSpacing: 0.5,
                  ),
                ),
                if (_hasActiveFilter)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: primaryRust,
                    ),
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text(
                      'Reset',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Grid Katalog Barang ─────────────────────────────────
            if (items.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: creamInput,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: darkBrown.withValues(alpha: 0.2)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: darkBrown),
                    SizedBox(height: 8),
                    Text(
                      'TIDAK ADA BARANG DITEMUKAN',
                      style: TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 16,
                        color: darkBrown,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Coba ubah kata kunci atau reset filter pencarian kamu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: primaryRust),
                    ),
                  ],
                ),
              )
            else
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
                  return SalingBeliCard(
                    item: item,
                    onTap: () {
                      _showDetailModal(context, item);
                    },
                    onChatTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Membuka chat dengan pemilik "${item.title}"'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),

            // ── Section Barang Tersimpan (Saved Items) ──────────────
            if (savedItems.isNotEmpty) ...[
              const SizedBox(height: 28),
              const Divider(color: darkBrown, thickness: 2),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    '★ BARANG TERSIMPAN',
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 15,
                      color: darkBrown,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: darkBrown,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Gratis & Favorit',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 68,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: savedItems.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 10),
                  itemBuilder: (context, idx) {
                    return MiniItemCard(
                      item: savedItems[idx],
                      onTap: () => _showDetailModal(context, savedItems[idx]),
                    );
                  },
                ),
              ),
            ],

            // ── Section Terakhir Dilihat ────────────────────────────
            if (recentlyViewed.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(color: darkBrown, thickness: 2),
              const SizedBox(height: 12),
              const Text(
                '🕒 TERAKHIR ANDA LIHAT',
                style: TextStyle(
                  fontFamily: 'Anton',
                  fontSize: 15,
                  color: darkBrown,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 68,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentlyViewed.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 10),
                  itemBuilder: (context, idx) {
                    return MiniItemCard(
                      item: recentlyViewed[idx],
                      onTap: () => _showDetailModal(context, recentlyViewed[idx]),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow({
    required String label,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Anton',
            fontSize: 11,
            color: primaryRust,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: children
                .map((child) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: child,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  void _showDetailModal(BuildContext context, ItemListing item) {
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
              item.title.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Anton',
                fontSize: 20,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.isFree ? '🎁 GRATIS (HIBAH)' : 'Rp${item.price}',
              style: TextStyle(
                fontFamily: 'Anton',
                fontSize: 18,
                color: item.isFree ? darkBrown : primaryRust,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.description,
              style: const TextStyle(fontSize: 13, color: darkBrown, height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: primaryRust),
                const SizedBox(width: 4),
                Text(
                  item.pickupLocation,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: darkBrown),
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
                        SnackBar(content: Text('Chat dimulai untuk ${item.title}')),
                      );
                    },
                    child: const Text('CHAT PENJUAL', style: TextStyle(fontFamily: 'Anton')),
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
}
