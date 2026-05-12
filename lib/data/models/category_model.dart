import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.isActive,
    required this.isFeatured,
    required this.priority,
    required this.numberOfProducts,
    required this.viewCount,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String imageURL;
  final bool isActive;
  final bool isFeatured;
  final int priority;
  final int numberOfProducts;
  final int viewCount;
  final String createdBy;
  final String updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CategoryModel.fromMap(String id, Map<String, dynamic> data) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      imageURL: data['imageURL'] ?? '',
      isActive: data['isActive'] ?? true,
      isFeatured: data['isFeatured'] ?? false,
      priority: data['priority'] ?? 0,
      numberOfProducts: data['numberOfProducts'] ?? 0,
      viewCount: data['viewCount'] ?? 0,
      createdBy: data['createdBy'] ?? '',
      updatedBy: data['updatedBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? imageURL,
    bool? isActive,
    bool? isFeatured,
    int? priority,
    int? numberOfProducts,
    int? viewCount,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageURL: imageURL ?? this.imageURL,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      priority: priority ?? this.priority,
      numberOfProducts: numberOfProducts ?? this.numberOfProducts,
      viewCount: viewCount ?? this.viewCount,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageURL': imageURL,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'priority': priority,
      'numberOfProducts': numberOfProducts,
      'viewCount': viewCount,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
