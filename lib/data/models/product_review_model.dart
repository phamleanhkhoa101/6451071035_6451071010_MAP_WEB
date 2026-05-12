import 'package:cloud_firestore/cloud_firestore.dart';

class ProductReviewModel {
  ProductReviewModel({
    required this.id,
    required this.productName,
    required this.customerName,
    required this.comment,
    required this.rating,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String productName;
  final String customerName;
  final String comment;
  final int rating;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProductReviewModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductReviewModel(
      id: id,
      productName: map['productName'] ?? '',
      customerName: map['customerName'] ?? '',
      comment: map['comment'] ?? '',
      rating: _toInt(map['rating']),
      status: map['status'] ?? 'pending',
      createdAt: _toDate(map['createdAt']),
      updatedAt: _toDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'customerName': customerName,
      'comment': comment,
      'rating': rating,
      'status': status,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
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

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
