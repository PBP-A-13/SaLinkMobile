import 'package:flutter/material.dart';
import 'package:salink_mobile/models/makanan.dart';
import 'package:salink_mobile/theme/salink_colors.dart';

class TambahMakananPage extends StatefulWidget {
  const TambahMakananPage({super.key});

  @override
  State<TambahMakananPage> createState() => _TambahMakananPageState();
}

class _TambahMakananPageState extends State<TambahMakananPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _porsiController = TextEditingController(text: '1');
  final _lokasiLainnyaController = TextEditingController();

  String _selectedLokasi = 'kancil';
  DateTime _batasLayak = DateTime.now().add(const Duration(hours: 4));

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _porsiController.dispose();
    _lokasiLainnyaController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _batasLayak,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_batasLayak),
    );
    if (pickedTime == null || !mounted) return;

    setState(() {
      _batasLayak = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/${dt.year} • $hour:$minute WIB';
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final newMakanan = Makanan(
      id: DateTime.now().millisecondsSinceEpoch,
      namaMakanan: _namaController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
      porsi: int.parse(_porsiController.text.trim()),
      lokasiPengambilan: _selectedLokasi,
      lokasiLainnya: _selectedLokasi == 'lainnya'
          ? _lokasiLainnyaController.text.trim()
          : '',
      batasLayakKonsumsi: _batasLayak,
      pemberi: 'Kamu',
    );

    Navigator.pop(context, newMakanan);
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(
        color: SaLinkColors.brown,
        fontWeight: FontWeight.w600,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SaLinkColors.brown, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SaLinkColors.orange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLainnya = _selectedLokasi == 'lainnya';

    return Scaffold(
      backgroundColor: SaLinkColors.cream,
      appBar: AppBar(
        title: const Text(
          'Bagikan Makanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: SaLinkColors.brown,
        foregroundColor: SaLinkColors.yellow,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                const SizedBox(height: 4),
                const Text(
                  'Detail Makanan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: SaLinkColors.brown,
                  ),
                ),
                const SizedBox(height: 20),

                // Nama Makanan
                TextFormField(
                  controller: _namaController,
                  decoration: _inputDecoration(
                    'Nama Makanan',
                    'Contoh: Nasi Kotak Ayam Geprek',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama makanan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Deskripsi
                TextFormField(
                  controller: _deskripsiController,
                  maxLines: 3,
                  decoration: _inputDecoration(
                    'Deskripsi',
                    'Ceritakan kondisi makanan, halal/tidak, catatan pengambilan...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Jumlah Porsi
                TextFormField(
                  controller: _porsiController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Jumlah Porsi', 'Minimal 1'),
                  validator: (value) {
                    final parsed = int.tryParse(value?.trim() ?? '');
                    if (parsed == null || parsed < 1) {
                      return 'Masukkan angka minimal 1 porsi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Lokasi Pengambilan
                const Text(
                  'Lokasi Pengambilan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: SaLinkColors.brown,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: SaLinkColors.brown, width: 1.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedLokasi,
                      isExpanded: true,
                      dropdownColor: SaLinkColors.creamLight,
                      style: const TextStyle(
                        color: SaLinkColors.brown,
                        fontSize: 15,
                      ),
                      items: Makanan.lokasiChoices.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedLokasi = value;
                          if (value != 'lainnya') {
                            _lokasiLainnyaController.clear();
                          }
                        });
                      },
                    ),
                  ),
                ),

                // Lokasi Lainnya (muncul hanya jika pilih "lainnya")
                if (isLainnya) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lokasiLainnyaController,
                    maxLength: 20,
                    decoration: _inputDecoration(
                      'Lokasi Lainnya',
                      'Contoh: Perpusat UI',
                    ),
                    validator: (value) {
                      if (isLainnya &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Isi nama lokasi lainnya';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 16),

                // Batas Layak Konsumsi
                const Text(
                  'Batas Layak Konsumsi',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: SaLinkColors.brown,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickDateTime,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SaLinkColors.brown, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDateTime(_batasLayak),
                          style: const TextStyle(
                            color: SaLinkColors.brown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: SaLinkColors.orange,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Simpan
                ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.volunteer_activism),
                  label: const Text(
                    'BAGIKAN SEKARANG',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SaLinkColors.orange,
                    foregroundColor: SaLinkColors.creamLight,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
        ),
      ),
    );
  }
}