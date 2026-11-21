class BorrowItem {
  final String id;
  final String name;
  final String description;
  final String category;
  final String condition;
  final int maxDurationDays;
  final String depositFee;
  final String pickupLocation;
  final String? imageUrl;
  final String status;
  final String ownerUsername;
  final bool isOwner;

  const BorrowItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.condition,
    required this.maxDurationDays,
    required this.depositFee,
    required this.pickupLocation,
    this.imageUrl,
    required this.status,
    required this.ownerUsername,
    this.isOwner = false,
  });

  bool get isAvailable => status == 'AVAILABLE';

  factory BorrowItem.fromJson(Map<String, dynamic> json) {
    return BorrowItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'OTHER',
      condition: json['condition']?.toString() ?? 'GOOD',
      maxDurationDays: json['max_duration_days'] is int
          ? json['max_duration_days']
          : int.tryParse(json['max_duration_days']?.toString() ?? '7') ?? 7,
      depositFee: json['deposit_fee']?.toString() ?? '0',
      pickupLocation: json['pickup_location']?.toString() ?? 'Perpustakaan Pusat UI',
      imageUrl: json['image_url']?.toString(),
      status: json['status']?.toString() ?? 'AVAILABLE',
      ownerUsername: json['owner']?.toString() ?? '',
      isOwner: json['is_owner'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'condition': condition,
      'max_duration_days': maxDurationDays,
      'deposit_fee': int.tryParse(depositFee) ?? 0,
      'pickup_location': pickupLocation,
      if (imageUrl != null && imageUrl!.isNotEmpty) 'image_url': imageUrl,
    };
  }

  String get categoryDisplay {
    switch (category) {
      case 'ACADEMIC':
        return 'Akademik & Formal';
      case 'TRAVEL':
        return 'Travel & Koper';
      case 'ELECTRONICS':
        return 'Elektronik & Aksesori';
      case 'TOOLS':
        return 'Peralatan & Hobi';
      default:
        return 'Lain-lain';
    }
  }

  String get conditionDisplay {
    switch (condition) {
      case 'LIKE_NEW':
        return 'Sangat Baik (Mulus)';
      case 'GOOD':
        return 'Baik / Layak Pakai';
      case 'FAIR':
        return 'Ada Minus';
      default:
        return condition;
    }
  }
}

class BorrowRequestItem {
  final String id;
  final String name;
  final String? imageUrl;
  final String pickupLocation;
  final String category;
  final String status;
  final String ownerUsername;

  const BorrowRequestItem({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.pickupLocation,
    required this.category,
    required this.status,
    required this.ownerUsername,
  });

  factory BorrowRequestItem.fromJson(Map<String, dynamic> json) {
    return BorrowRequestItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      pickupLocation: json['pickup_location']?.toString() ?? 'Perpustakaan Pusat UI',
      category: json['category']?.toString() ?? 'OTHER',
      status: json['status']?.toString() ?? 'AVAILABLE',
      ownerUsername: json['owner']?.toString() ?? '',
    );
  }
}

class ActiveBorrowSlot {
  final String id;
  final BorrowRequestItem item;
  final String borrowerUsername;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? actualReturnDate;
  final String notes;
  final String status; // PENDING, APPROVED, ONGOING, RETURNED, REJECTED, CANCELLED

  // Konfirmasi Serah-Terima Dua Arah (Two-Way Handover & Return)
  final bool ownerHandoverConfirmed;
  final bool borrowerHandoverConfirmed;
  final bool borrowerReturnConfirmed;
  final bool ownerReturnConfirmed;

  final bool canConfirmHandover;
  final bool canConfirmReturn;
  final String handoverStatusDisplay;
  final String returnStatusDisplay;
  final bool canCancel;

  ActiveBorrowSlot({
    required this.id,
    BorrowRequestItem? item,
    String? itemName,
    String? pickupLocation,
    String? imageUrl,
    this.borrowerUsername = '',
    required this.startDate,
    required this.endDate,
    this.actualReturnDate,
    this.notes = '',
    required this.status,
    this.ownerHandoverConfirmed = false,
    this.borrowerHandoverConfirmed = false,
    this.borrowerReturnConfirmed = false,
    this.ownerReturnConfirmed = false,
    this.canConfirmHandover = false,
    this.canConfirmReturn = false,
    this.handoverStatusDisplay = '',
    this.returnStatusDisplay = '',
    this.canCancel = false,
  }) : item = item ??
            BorrowRequestItem(
              id: id,
              name: itemName ?? '',
              pickupLocation: pickupLocation ?? '',
              imageUrl: imageUrl,
              category: 'OTHER',
              status: 'AVAILABLE',
              ownerUsername: '',
            );

  // Backward compatibility getters
  String get itemName => item.name;
  String? get imageUrl => item.imageUrl;
  String get pickupLocation => item.pickupLocation;

  factory ActiveBorrowSlot.fromJson(Map<String, dynamic> json) {
    return ActiveBorrowSlot(
      id: json['id']?.toString() ?? '',
      item: BorrowRequestItem.fromJson(json['item'] as Map<String, dynamic>? ?? {}),
      borrowerUsername: json['borrower']?.toString() ?? '',
      startDate: DateTime.tryParse(json['start_date']?.toString() ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date']?.toString() ?? '') ?? DateTime.now(),
      actualReturnDate: json['actual_return_date'] != null
          ? DateTime.tryParse(json['actual_return_date'].toString())
          : null,
      notes: json['notes']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING',
      ownerHandoverConfirmed: json['owner_handover_confirmed'] == true,
      borrowerHandoverConfirmed: json['borrower_handover_confirmed'] == true,
      borrowerReturnConfirmed: json['borrower_return_confirmed'] == true,
      ownerReturnConfirmed: json['owner_return_confirmed'] == true,
      canConfirmHandover: json['can_confirm_handover'] == true,
      canConfirmReturn: json['can_confirm_return'] == true,
      handoverStatusDisplay: json['handover_status_display']?.toString() ?? '',
      returnStatusDisplay: json['return_status_display']?.toString() ?? '',
      canCancel: json['can_cancel'] == true,
    );
  }

  String get statusDisplay {
    switch (status) {
      case 'PENDING':
        return 'Menunggu Persetujuan';
      case 'APPROVED':
        if (ownerHandoverConfirmed || borrowerHandoverConfirmed) {
          return 'Menunggu Konfirmasi Serah';
        }
        return 'Disetujui';
      case 'ONGOING':
        if (borrowerReturnConfirmed || ownerReturnConfirmed) {
          return 'Menunggu Konfirmasi Kembali';
        }
        return 'Sedang Berlangsung';
      case 'RETURNED':
        return 'Selesai Dikembalikan';
      case 'REJECTED':
        return 'Ditolak';
      case 'CANCELLED':
        return 'Dibatalkan';
      default:
        return status;
    }
  }
}
