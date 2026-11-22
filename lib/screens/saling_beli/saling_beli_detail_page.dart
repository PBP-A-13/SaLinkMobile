import 'package:flutter/material.dart';
import 'package:salink_mobile/models/item_listing.dart';
import 'package:salink_mobile/screens/saling_beli/saling_beli_form_page.dart';
import 'package:salink_mobile/screens/saling_beli/saling_beli_theme.dart';
import 'package:salink_mobile/services/auth_service.dart';
import 'package:salink_mobile/services/saling_beli_service.dart';

class SalingBeliDetailPage extends StatefulWidget {
  final ItemListing initialItem;

  const SalingBeliDetailPage({
    super.key,
    required this.initialItem,
  });

  @override
  State<SalingBeliDetailPage> createState() => _SalingBeliDetailPageState();
}

class _SalingBeliDetailPageState extends State<SalingBeliDetailPage> {
  static const darkBrown = Color(0xFF4D2A00);
  static const primaryRust = Color(0xFFCC6F00);
  static const marigoldYellow = Color(0xFFF2A900);
  static const butterBg = Color(0xFFF9E6A8);
  static const creamInput = Color(0xFFFFF6DC);

  final SalingBeliService _apiService = SalingBeliService();
  final AuthService _authService = AuthService();

  late ItemListing _item;
  bool _isLoading = false;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _item = widget.initialItem;
    _checkCurrentUser();
    _refreshDetail();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final profile = await _authService.getProfile();
      if (mounted) {
        setState(() {
          _currentUserId = profile['id'];
        });
      }
    } catch (_) {}
  }

  Future<void> _refreshDetail() async {
    try {
      final updated = await _apiService.fetchListingDetail(_item.id);
      if (mounted) {
        setState(() {
          _item = updated;
        });
      }
    } catch (_) {}
  }

  bool get _isOwner => _currentUserId != null && _item.userId == _currentUserId;

  Future<void> _deleteItem() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: creamInput,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkBrown, width: 2),
        ),
        title: const Text(
          'HAPUS BARANG',
          style: TextStyle(fontFamily: 'Anton', color: darkBrown),
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus barang "${_item.title}" dari katalog?',
          style: const TextStyle(fontSize: 13, color: darkBrown),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('BATAL', style: TextStyle(color: darkBrown, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('HAPUS', style: TextStyle(fontFamily: 'Anton')),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isLoading = true);
    try {
      final success = await _apiService.deleteListing(_item.id);
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang berhasil dihapus!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus barang.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final num priceNum = num.tryParse(_item.price) ?? 0;

    return Scaffold(
      backgroundColor: butterBg,
      appBar: AppBar(
        backgroundColor: darkBrown,
        foregroundColor: marigoldYellow,
        elevation: 0,
        title: const Text(
          'Detail Barang',
          style: TextStyle(
            fontFamily: 'Anton',
            fontSize: 22,
            color: marigoldYellow,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          if (_isOwner) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: marigoldYellow),
              tooltip: 'Edit Barang',
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SalingBeliFormPage(itemToEdit: _item),
                  ),
                );
                if (result == true) {
                  _refreshDetail();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFFF8A80)),
              tooltip: 'Hapus Barang',
              onPressed: _isLoading ? null : _deleteItem,
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar Utama
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: creamInput,
                  border: Border.all(color: darkBrown, width: 2),
                ),
                child: _item.displayImage != null && _item.displayImage!.isNotEmpty
                    ? Image.network(
                        _item.displayImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
            const SizedBox(height: 16),

            // Card Info Utama
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: creamInput,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price
                  Text(
                    _item.title.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 22,
                      color: darkBrown,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_item.isFree)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: darkBrown,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '🎁 GRATIS (HIBAH)',
                        style: TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    Text(
                      formatRupiah(priceNum),
                      style: const TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 24,
                        color: primaryRust,
                      ),
                    ),
                  const SizedBox(height: 14),
                  const Divider(color: darkBrown, thickness: 1.5),
                  const SizedBox(height: 10),

                  // Detail Metadata
                  _buildMetaRow('KATEGORI', _item.category),
                  _buildMetaRow('KONDISI', _item.condition),
                  _buildMetaRow('LOKASI COD', _item.pickupLocation),
                  _buildMetaRow('STATUS', _item.status),

                  const SizedBox(height: 14),
                  const Text(
                    'DESKRIPSI BARANG',
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 14,
                      color: primaryRust,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _item.description.isNotEmpty ? _item.description : 'Tidak ada deskripsi.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: darkBrown,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Aksi Kontak / Pesan
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRust,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Fitur chat/nego dibuka untuk "${_item.title}"'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text(
                        'HUBUNGI PENJUAL',
                        style: TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Anton',
                fontSize: 12,
                color: Color(0xFF8C5A1F),
                letterSpacing: 0.3,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.bold, color: darkBrown)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: darkBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, color: primaryRust, size: 48),
          SizedBox(height: 8),
          Text(
            'FOTO TIDAK TERSEDIA',
            style: TextStyle(
              fontFamily: 'Anton',
              fontSize: 12,
              color: darkBrown,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
