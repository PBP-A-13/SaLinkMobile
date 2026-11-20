class Makanan {
  final int id;
  final String namaMakanan;
  final String deskripsi;
  final int porsi;
  final String? foto;
  final String lokasiPengambilan;
  final String lokasiLainnya;
  final DateTime batasLayakKonsumsi;
  final bool isAvailable;
  final String pemberi;

  const Makanan({
    required this.id,
    required this.namaMakanan,
    required this.deskripsi,
    required this.porsi,
    this.foto,
    required this.lokasiPengambilan,
    this.lokasiLainnya = '',
    required this.batasLayakKonsumsi,
    this.isAvailable = true,
    required this.pemberi,
  });

  static const Map<String, String> lokasiChoices = {
    'kanmer': 'Kanmer (Kantin FH)',
    'kanvok': 'Kanvok (Kantin Vokasi)',
    'kancil': 'Kancil (Kantin Fasilkom)',
    'dallas': 'Dallas (Kantin FMIPA)',
    'kansas': 'Kansas (Kantin FIB)',
    'kanrik': 'Kanrik (Kantin RIK)',
    'kantek': 'Kantek (Kantin Teknik)',
    'bamen': 'Bamen (Kantin FIA)',
    'takor': 'Takor (Kantin FISIP)',
    'lainnya': 'Lainnya',
  };

  String get namaLokasi {
    if (lokasiPengambilan == 'lainnya') {
      return lokasiLainnya.isNotEmpty ? lokasiLainnya : 'Lokasi lainnya';
    }
    return lokasiChoices[lokasiPengambilan] ?? lokasiPengambilan;
  }

  factory Makanan.fromJson(Map<String, dynamic> json) {
    return Makanan(
      id: json['id'] as int,
      namaMakanan: json['nama_makanan'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',
      porsi: json['porsi'] as int? ?? 1,
      foto: json['foto'] as String?,
      lokasiPengambilan: json['lokasi_pengambilan'] as String? ?? 'kancil',
      lokasiLainnya: json['lokasi_lainnya'] as String? ?? '',
      batasLayakKonsumsi: DateTime.parse(
        json['batas_layak_konsumsi'] as String,
      ),
      isAvailable: json['is_available'] as bool? ?? true,
      pemberi: json['pemberi']?.toString() ?? 'Mahasiswa UI',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_makanan': namaMakanan,
      'deskripsi': deskripsi,
      'porsi': porsi,
      'lokasi_pengambilan': lokasiPengambilan,
      'lokasi_lainnya': lokasiLainnya,
      'batas_layak_konsumsi': batasLayakKonsumsi.toIso8601String(),
      'is_available': isAvailable,
    };
  }
}

class JanjiTemu {
  final int id;
  final int makananId;
  final String pengambil;
  final DateTime waktuJanji;
  final String status;

  const JanjiTemu({
    required this.id,
    required this.makananId,
    required this.pengambil,
    required this.waktuJanji,
    this.status = 'PENDING',
  });

  static const Map<String, String> statusChoices = {
    'PENDING': 'Menunggu Persetujuan',
    'APPROVED': 'Disetujui',
    'REJECTED': 'Ditolak',
    'COMPLETED': 'Selesai',
  };

  String get statusDisplay => statusChoices[status] ?? status;

  factory JanjiTemu.fromJson(Map<String, dynamic> json) {
    return JanjiTemu(
      id: json['id'] as int,
      makananId: json['makanan'] as int,
      pengambil: json['pengambil']?.toString() ?? '',
      waktuJanji: DateTime.parse(json['waktu_janji'] as String),
      status: json['status'] as String? ?? 'PENDING',
    );
  }
}

/// Data dummy sementara untuk Checkpoint 1 (akan diganti fetch API DRF).
final List<Makanan> dummyMakananList = [
  Makanan(
    id: 1,
    namaMakanan: 'Nasi Kotak Ayam Bakar',
    deskripsi:
        'Sisa konsumsi rapat BEM Fasilkom masih baru dan tersegel rapi. Ambil di depan Kancil ya!',
    porsi: 4,
    lokasiPengambilan: 'kancil',
    batasLayakKonsumsi: DateTime.now().add(const Duration(hours: 5)),
    pemberi: 'hasbi_si25',
  ),
  Makanan(
    id: 2,
    namaMakanan: 'Snack Box Seminar (Risol & Lemper)',
    deskripsi:
        'Masih hangat dari acara seminar di Gedung A. Cocok buat ganjal perut sore.',
    porsi: 6,
    lokasiPengambilan: 'kantek',
    batasLayakKonsumsi: DateTime.now().add(const Duration(hours: 3)),
    pemberi: 'anak_teknik',
  ),
  Makanan(
    id: 3,
    namaMakanan: 'Roti Tawar & Selai Cokelat',
    deskripsi:
        'Baru beli kemarin, besok mau pulang kampung jadi daripada mubazir silakan ambil.',
    porsi: 2,
    lokasiPengambilan: 'lainnya',
    lokasiLainnya: 'Perpusat UI (Lobi)',
    batasLayakKonsumsi: DateTime.now().add(const Duration(days: 1)),
    pemberi: 'pejuang_skripsi',
  ),
];