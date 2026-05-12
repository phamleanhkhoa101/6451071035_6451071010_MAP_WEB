import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  ProductModel({
    required this.id,
    required this.title,
    required this.sku,
    required this.brand,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.stock,
    required this.status,
    required this.summary,
    required this.imageUrl,
    required this.isFeatured,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String sku;
  final String brand;
  final String category;
  final double price;
  final double originalPrice;
  final int stock;
  final String status;
  final String summary;
  final String imageUrl;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      title: map['title'] ?? '',
      sku: map['sku'] ?? '',
      brand: map['brand'] ?? map['brandName'] ?? '',
      category: map['category'] ?? map['categoryName'] ?? '',
      price: _toDouble(map['price'] ?? map['salePrice']),
      originalPrice: _toDouble(map['originalPrice'] ?? map['salePrice']),
      stock: _toInt(map['stock']),
      status: _statusFromMap(map),
      summary: map['summary'] ?? map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? map['thumbnail'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
      createdAt: _toDate(map['createdAt']),
      updatedAt: _toDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    final isPublished = status == 'published';
    final isDraft = status == 'draft';
    final isArchived = status == 'archived';

    return {
      'title': title,
      'sku': sku,
      'brand': brand,
      'brandName': brand,
      'category': category,
      'categoryName': category,
      'price': price,
      'originalPrice': originalPrice,
      'salePrice': originalPrice,
      'stock': stock,
      'status': status,
      'summary': summary,
      'description': summary,
      'imageUrl': imageUrl,
      'thumbnail': imageUrl,
      'isFeatured': isFeatured,
      'isActive': isPublished,
      'isDraft': isDraft,
      'isDeleted': isArchived,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static String _statusFromMap(Map<String, dynamic> map) {
    final explicitStatus = map['status']?.toString().trim();
    if (explicitStatus != null && explicitStatus.isNotEmpty) {
      return explicitStatus;
    }

    if (map['isDeleted'] == true) {
      return 'archived';
    }
    if (map['isDraft'] == true) {
      return 'draft';
    }
    if (map['isActive'] == true) {
      return 'published';
    }
    return 'draft';
  }

  static DateTime? _toDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
