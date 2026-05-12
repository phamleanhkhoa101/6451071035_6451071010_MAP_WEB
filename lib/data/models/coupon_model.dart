import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  CouponModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderValue,
    required this.maxDiscountValue,
    required this.usageLimit,
    required this.usedCount,
    required this.isActive,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String code;
  final String description;
  final String discountType;
  final double discountValue;
  final double minOrderValue;
  final double maxDiscountValue;
  final int usageLimit;
  final int usedCount;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CouponModel.fromMap(Map<String, dynamic> map, String id) {
    return CouponModel(
      id: id,
      code: map['code'] ?? '',
      description: map['description'] ?? '',
      discountType: map['discountType'] ?? 'percent',
      discountValue: _toDouble(map['discountValue']),
      minOrderValue: _toDouble(map['minOrderValue']),
      maxDiscountValue: _toDouble(map['maxDiscountValue']),
      usageLimit: _toInt(map['usageLimit']),
      usedCount: _toInt(map['usedCount']),
      isActive: map['isActive'] ?? true,
      startDate: (map['startDate'] as Timestamp?)?.toDate(),
      endDate: (map['endDate'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minOrderValue': minOrderValue,
      'maxDiscountValue': maxDiscountValue,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
      'startDate': startDate == null ? null : Timestamp.fromDate(startDate!),
      'endDate': endDate == null ? null : Timestamp.fromDate(endDate!),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
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
