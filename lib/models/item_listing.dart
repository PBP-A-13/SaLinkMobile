import 'dart:convert';

List<ItemListing> itemListingFromJson(String str) =>
    List<ItemListing>.from(json.decode(str).map((x) => ItemListing.fromJson(x)));

String itemListingToJson(List<ItemListing> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemListing {
  final String id;
  final int? userId;
  final String title;
  final String description;
  final String category;
  final String condition;
  final bool isFree;
  final String price;
  final String? imageUrl;
  final String? image;
  final String? displayImage;
  final String pickupLocation;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemListing({
    required this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.condition,
    required this.isFree,
    required this.price,
    this.imageUrl,
    this.image,
    this.displayImage,
    required this.pickupLocation,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemListing.fromJson(Map<String, dynamic> json) => ItemListing(
        id: json["id"] ?? "",
        userId: json["user_id"],
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        category: json["category"] ?? "",
        condition: json["condition"] ?? "",
        isFree: json["is_free"] ?? false,
        price: json["price"]?.toString() ?? "0",
        imageUrl: json["image_url"],
        image: json["image"],
        displayImage: json["display_image"],
        pickupLocation: json["pickup_location"] ?? "",
        status: json["status"] ?? "",
        createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "description": description,
        "category": category,
        "condition": condition,
        "is_free": isFree,
        "price": price,
        "image_url": imageUrl,
        "image": image,
        "display_image": displayImage,
        "pickup_location": pickupLocation,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
