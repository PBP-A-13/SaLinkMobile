import 'package:flutter/material.dart';
import 'package:salink_mobile/models/makanan.dart';
import 'package:salink_mobile/screens/saling_bagi/tambah_makanan_page.dart';
import 'package:salink_mobile/theme/salink_colors.dart';

class SalingBagiPage extends StatefulWidget {
  const SalingBagiPage({super.key});

  @override
  State<SalingBagiPage> createState() => _SalingBagiPageState();
}

class _SalingBagiPageState extends State<SalingBagiPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<Makanan> _makananList;
  String _selectedLokasi = 'semua';
  String _selectedSort = 'terbaru';

  @override
  void initState() {
    super.initState();
    _makananList = List<Makanan>.from(dummyMakananList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Makanan> get _filteredMakanan {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _makananList.where((makanan) {
      final matchQuery = query.isEmpty ||
          makanan.namaMakanan.toLowerCase().contains(query) ||
          makanan.deskripsi.toLowerCase().contains(query);
      final matchLokasi = _selectedLokasi == 'semua' ||
          makanan.lokasiPengambilan == _selectedLokasi;
      return matchQuery && matchLokasi && makanan.isAvailable;
    }).toList();

    if (_selectedSort == 'porsi') {
      filtered.sort((a, b) => b.porsi.compareTo(a.porsi));
    } else if (_selectedSort == 'segera_habis') {
      filtered.sort(
        (a, b) => a.batasLayakKonsumsi.compareTo(b.batasLayakKonsumsi),
      );
    } else {
      filtered.sort((a, b) => b.id.compareTo(a.id));
    }
    return filtered;
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/${dt.year}, $hour:$minute WIB';
  }

  Future<void> _openTambahMakanan() async {
    final result = await Navigator.push<Makanan>(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahMakananPage(),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _makananList.insert(0, result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: SaLinkColors.brown,
          content: Text(
            '"${result.namaMakanan}" berhasil dibagikan!',
            style: const TextStyle(color: SaLinkColors.creamLight),
          ),
        ),
      );
    }
  }

  void _showDetailAndJanjiSheet(Makanan makanan) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: SaLinkColors.creamLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: SaLinkColors.brown, width: 2),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      makanan.namaMakanan,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: SaLinkColors.brown,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: SaLinkColors.yellow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SaLinkColors.brown, width: 1.5),
                    ),
                    child: Text(
                      '${makanan.porsi} Porsi',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: SaLinkColors.brown,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                makanan.deskripsi,
                style: const TextStyle(
                  color: SaLinkColors.brown,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.location_on_outlined, makanan.namaLokasi),
              const SizedBox(height: 6),
              _buildInfoRow(
                Icons.access_time,
                'Layak hingga: ${_formatDateTime(makanan.batasLayakKonsumsi)}',
              ),
              const SizedBox(height: 6),
              _buildInfoRow(
                Icons.person_outline,
                'Dibagikan oleh @${makanan.pemberi}',
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: SaLinkColors.brown,
                      content: Text(
                        'Permintaan janji temu untuk "${makanan.namaMakanan}" dikirim (Pending).',
                        style: const TextStyle(color: SaLinkColors.creamLight),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.handshake_outlined),
                label: const Text(
                  'AJUKAN JANJI TEMU',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SaLinkColors.orange,
                  foregroundColor: SaLinkColors.creamLight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: SaLinkColors.brown, width: 2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: SaLinkColors.orange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: SaLinkColors.brown,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedList = _filteredMakanan;

    return Scaffold(
      backgroundColor: SaLinkColors.cream,
      appBar: AppBar(
        title: const Text(
          'Saling Bagi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: SaLinkColors.brown,
        foregroundColor: SaLinkColors.yellow,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HERO CARD (mengikuti gaya web Saling Bagi)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: SaLinkColors.creamLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: SaLinkColors.brown, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: SaLinkColors.brown,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SHARE FOOD, SHARE KINDNESS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: SaLinkColors.orange,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: SaLinkColors.brown,
                      ),
                      children: [
                        TextSpan(text: 'Saling Bagi '),
                        TextSpan(
                          text: 'Makanan.',
                          style: TextStyle(color: SaLinkColors.orange),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Punya makanan berlebih? Jangan dibuang! Bagikan kepada sesama mahasiswa UI dan bantu mengurangi food waste di lingkungan kampus.',
                    style: TextStyle(
                      fontSize: 13,
                      color: SaLinkColors.brown,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _openTambahMakanan,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text(
                      'BAGIKAN MAKANAN →',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SaLinkColors.orange,
                      foregroundColor: SaLinkColors.creamLight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: const BorderSide(
                          color: SaLinkColors.brown,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // HEADER TEMUKAN MAKANAN + COUNTER BADGE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FOOD SHARING COMMUNITY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: SaLinkColors.orange,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Temukan Makanan',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: SaLinkColors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: SaLinkColors.brown,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${displayedList.length} TERSEDIA',
                    style: const TextStyle(
                      color: SaLinkColors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // FILTER & SEARCH BOX
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: SaLinkColors.creamLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: SaLinkColors.brown, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: SaLinkColors.brown,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Cari nama makanan atau deskripsi...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: SaLinkColors.brown,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: SaLinkColors.brown,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: SaLinkColors.orange,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Filter Lokasi
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: SaLinkColors.brown,
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedLokasi,
                              isExpanded: true,
                              dropdownColor: SaLinkColors.creamLight,
                              style: const TextStyle(
                                color: SaLinkColors.brown,
                                fontSize: 13,
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: 'semua',
                                  child: Text('Semua Lokasi'),
                                ),
                                ...Makanan.lokasiChoices.entries.map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e.key,
                                    child: Text(
                                      e.value,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _selectedLokasi = value);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Urutkan
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: SaLinkColors.brown,
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSort,
                              isExpanded: true,
                              dropdownColor: SaLinkColors.creamLight,
                              style: const TextStyle(
                                color: SaLinkColors.brown,
                                fontSize: 13,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'terbaru',
                                  child: Text('Terbaru'),
                                ),
                                DropdownMenuItem(
                                  value: 'porsi',
                                  child: Text('Porsi Terbanyak'),
                                ),
                                DropdownMenuItem(
                                  value: 'segera_habis',
                                  child: Text('Segera Kedaluwarsa'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _selectedSort = value);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // LIST MAKANAN ATAU EMPTY STATE
            if (displayedList.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 36,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: SaLinkColors.creamLight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: SaLinkColors.brown, width: 2),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.fastfood_outlined,
                      size: 56,
                      color: SaLinkColors.orange,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Belum Ada Makanan Dibagikan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: SaLinkColors.brown,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Jadilah orang pertama yang berbagi makanan dan sebarkan kebaikan di lingkungan kampus!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: SaLinkColors.brown,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...displayedList.map(_buildMakananCard),

            const SizedBox(height: 20),

            // FOOTER BANNER ("Satu Makanan, Banyak Kebaikan.")
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: SaLinkColors.brown,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SMALL ACTS, BIG IMPACT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: SaLinkColors.yellow,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Satu Makanan, Banyak Kebaikan.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: SaLinkColors.creamLight,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kurangi makanan terbuang dan bangun budaya saling berbagi.',
                          style: TextStyle(
                            fontSize: 12,
                            color: SaLinkColors.cream,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(
                    Icons.favorite,
                    color: SaLinkColors.yellow,
                    size: 36,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMakananCard(Makanan makanan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: SaLinkColors.creamLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SaLinkColors.brown, width: 2),
        boxShadow: const [
          BoxShadow(
            color: SaLinkColors.brown,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showDetailAndJanjiSheet(makanan),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: SaLinkColors.cream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SaLinkColors.brown, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.lunch_dining,
                      color: SaLinkColors.orange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          makanan.namaMakanan,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: SaLinkColors.brown,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'oleh @${makanan.pemberi}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: SaLinkColors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: SaLinkColors.yellow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SaLinkColors.brown, width: 1.5),
                    ),
                    child: Text(
                      '${makanan.porsi} Porsi',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: SaLinkColors.brown,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                makanan.deskripsi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: SaLinkColors.brown,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: SaLinkColors.cream, thickness: 1.5),
              const SizedBox(height: 6),
              _buildInfoRow(Icons.location_on_outlined, makanan.namaLokasi),
              const SizedBox(height: 4),
              _buildInfoRow(
                Icons.schedule,
                'Batas: ${_formatDateTime(makanan.batasLayakKonsumsi)}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}