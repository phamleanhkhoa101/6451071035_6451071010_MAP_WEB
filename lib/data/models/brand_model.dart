import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  BrandModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.isActive,
    required this.isFeatured,
    required this.priority,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final bool isActive;
  final bool isFeatured;
  final int priority;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory BrandModel.fromMap(Map<String, dynamic> map, String id) {
    return BrandModel(
      id: id,
      name: map['name'] ?? '',
      logoUrl: map['logoUrl'] ?? map['logoURL'] ?? '',
      description: map['description'] ?? '',
      isActive: map['isActive'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
      priority: map['priority'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logoUrl': logoUrl,
      'description': description,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'priority': priority,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
