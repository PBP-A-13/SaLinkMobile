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
  });

  bool get isAvailable => status == 'AVAILABLE';

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

class ActiveBorrowSlot {
  final String id;
  final String itemName;
  final String? imageUrl;
  final String pickupLocation;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // PENDING, APPROVED, ONGOING

  const ActiveBorrowSlot({
    required this.id,
    required this.itemName,
    this.imageUrl,
    required this.pickupLocation,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  String get statusDisplay {
    switch (status) {
      case 'PENDING':
        return 'Menunggu Persetujuan';
      case 'APPROVED':
        return 'Disetujui, Siap Diambil';
      case 'ONGOING':
        return 'Sedang Kamu Pinjam';
      default:
        return status;
    }
  }
}
