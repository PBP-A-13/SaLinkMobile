import 'package:flutter/material.dart';
import 'package:salink_mobile/models/item_listing.dart';
import 'package:salink_mobile/services/saling_beli_service.dart';

class SalingBeliFormPage extends StatefulWidget {
  final ItemListing? itemToEdit;

  const SalingBeliFormPage({super.key, this.itemToEdit});

  @override
  State<SalingBeliFormPage> createState() => _SalingBeliFormPageState();
}

class _SalingBeliFormPageState extends State<SalingBeliFormPage> {
  static const darkBrown = Color(0xFF4D2A00);
  static const primaryRust = Color(0xFFCC6F00);
  static const marigoldYellow = Color(0xFFF2A900);
  static const butterBg = Color(0xFFF9E6A8);
  static const creamInput = Color(0xFFFFF6DC);

  final _formKey = GlobalKey<FormState>();
  final SalingBeliService _apiService = SalingBeliService();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _pickupLocationController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _accountNameController;

  bool _isFree = false;
  String _category = 'FURNITURE';
  String _condition = 'GOOD';
  String _payoutMethod = 'BCA';
  bool _isLoading = false;

  final List<Map<String, String>> _categoryOptions = [
    {'value': 'FURNITURE', 'label': 'Furnitur & Perabot Kos'},
    {'value': 'ELECTRONICS', 'label': 'Elektronik & Gadget'},
    {'value': 'BOOKS', 'label': 'Buku & Alat Tulis'},
    {'value': 'CLOTHING', 'label': 'Pakaian & Aksesori'},
    {'value': 'KITCHEN', 'label': 'Peralatan Dapur'},
    {'value': 'OTHER', 'label': 'Lain-lain'},
  ];

  final List<Map<String, String>> _conditionOptions = [
    {'value': 'BRAND_NEW', 'label': 'Baru / Belum Pernah Dipakai'},
    {'value': 'LIKE_NEW', 'label': 'Seperti Baru (Mulus)'},
    {'value': 'GOOD', 'label': 'Baik / Layak Pakai'},
    {'value': 'FAIR', 'label': 'Ada Minus (Berfungsi)'},
  ];

  final List<String> _payoutMethods = [
    'BCA',
    'Mandiri',
    'BRI',
    'BNI',
    'GoPay',
    'OVO',
    'ShopeePay',
    'DANA',
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;
    _titleController = TextEditingController(text: item?.title ?? '');
    _descriptionController = TextEditingController(text: item?.description ?? '');
    _priceController = TextEditingController(text: item != null && !item.isFree ? item.price : '');
    _imageUrlController = TextEditingController(text: item?.imageUrl ?? item?.displayImage ?? '');
    _pickupLocationController = TextEditingController(
      text: item?.pickupLocation.isNotEmpty == true ? item!.pickupLocation : 'Perpustakaan Pusat UI',
    );
    _accountNumberController = TextEditingController();
    _accountNameController = TextEditingController();

    if (item != null) {
      _isFree = item.isFree;
      _category = item.category;
      _condition = item.condition;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _pickupLocationController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final payload = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': _category,
      'condition': _condition,
      'is_free': _isFree,
      'price': _isFree ? '0' : _priceController.text.trim(),
      'image_url': _imageUrlController.text.trim().isNotEmpty ? _imageUrlController.text.trim() : null,
      'pickup_location': _pickupLocationController.text.trim(),
      'payout_method': _isFree ? '' : _payoutMethod,
      'payout_account_name': _isFree ? '' : _accountNameController.text.trim(),
      'payout_account_number': _isFree ? '' : _accountNumberController.text.trim(),
    };

    try {
      Map<String, dynamic> result;
      if (widget.itemToEdit != null) {
        result = await _apiService.updateListing(widget.itemToEdit!.id, payload);
      } else {
        result = await _apiService.createListing(payload);
      }

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.itemToEdit != null
                ? 'Barang berhasil diperbarui!'
                : 'Barang berhasil didaftarkan ke katalog!'),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal menyimpan barang.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.itemToEdit != null;

    return Scaffold(
      backgroundColor: butterBg,
      appBar: AppBar(
        backgroundColor: darkBrown,
        foregroundColor: marigoldYellow,
        elevation: 0,
        title: Text(
          isEdit ? 'Edit Barang' : 'Jual / Hibah Barang',
          style: const TextStyle(
            fontFamily: 'Anton',
            fontSize: 22,
            color: marigoldYellow,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: creamInput,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: darkBrown, width: 2),
                  boxShadow: const [
                    BoxShadow(color: darkBrown, offset: Offset(4, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'INFORMASI BARANG',
                      style: TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 16,
                        color: darkBrown,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Judul Barang
                    _buildLabel('NAMA BARANG *'),
                    TextFormField(
                      controller: _titleController,
                      decoration: _buildInputDecoration('Contoh: Meja Belajar Lipat Kayu'),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Nama barang wajib diisi.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Kategori
                    _buildLabel('KATEGORI *'),
                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: _buildInputDecoration(''),
                      items: _categoryOptions
                          .map((c) => DropdownMenuItem(value: c['value'], child: Text(c['label']!)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _category = val);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Kondisi
                    _buildLabel('KONDISI BARANG *'),
                    DropdownButtonFormField<String>(
                      value: _condition,
                      decoration: _buildInputDecoration(''),
                      items: _conditionOptions
                          .map((c) => DropdownMenuItem(value: c['value'], child: Text(c['label']!)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _condition = val);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Switch Barang Gratis
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Berikan Gratis / Hibah',
                          style: TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 13,
                            color: darkBrown,
                          ),
                        ),
                        Switch(
                          value: _isFree,
                          activeColor: primaryRust,
                          onChanged: (val) {
                            setState(() => _isFree = val);
                          },
                        ),
                      ],
                    ),

                    if (!_isFree) ...[
                      const SizedBox(height: 10),
                      _buildLabel('HARGA (RP) *'),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration('Contoh: 50000'),
                        validator: (val) {
                          if (!_isFree) {
                            if (val == null || val.trim().isEmpty) return 'Harga wajib diisi.';
                            final numVal = num.tryParse(val.trim());
                            if (numVal == null || numVal <= 0) return 'Harga harus lebih besar dari 0.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      _buildLabel('METODE PENCAIRAN DANA *'),
                      DropdownButtonFormField<String>(
                        value: _payoutMethod,
                        decoration: _buildInputDecoration(''),
                        items: _payoutMethods
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _payoutMethod = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      _buildLabel('NOMOR REKENING / E-WALLET *'),
                      TextFormField(
                        controller: _accountNumberController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration('Contoh: 08123456789 atau 1234567890'),
                        validator: (val) {
                          if (!_isFree && (val == null || val.trim().isEmpty)) {
                            return 'Nomor rekening/e-wallet wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 14),
                    _buildLabel('LOKASI COD / KAMPUS *'),
                    TextFormField(
                      controller: _pickupLocationController,
                      decoration: _buildInputDecoration('Contoh: Perpustakaan Pusat UI, Fasilkom'),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Lokasi COD wajib diisi.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('TAUTAN FOTO (OPSIONAL)'),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: _buildInputDecoration('https://... (URL foto barang)'),
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('DESKRIPSI LENGKAP'),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: _buildInputDecoration('Ceritakan kondisi barang secara jujur...'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Simpan
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRust,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          isEdit ? 'SIMPAN PERUBAHAN' : 'TAYANGKAN BARANG',
                          style: const TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Anton',
          fontSize: 11,
          color: primaryRust,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF8C5A1F)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: darkBrown, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: darkBrown, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryRust, width: 2),
      ),
    );
  }
}
