import 'package:cloud_firestore/cloud_firestore.dart';

class AttributeModel {
  AttributeModel({
    required this.id,
    required this.name,
    required this.attributeValues,
    required this.isActive,
    required this.isSearchable,
    required this.isFilterable,
    required this.isColorAttribute,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final List<String> attributeValues;
  final bool isActive;
  final bool isSearchable;
  final bool isFilterable;
  final bool isColorAttribute;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AttributeModel.fromMap(Map<String, dynamic> map, String id) {
    return AttributeModel(
      id: id,
      name: map['name'] ?? '',
      attributeValues: List<String>.from(map['attributeValues'] ?? const []),
      isActive: map['isActive'] ?? true,
      isSearchable: map['isSearchable'] ?? false,
      isFilterable: map['isFilterable'] ?? false,
      isColorAttribute: map['isColorAttribute'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'attributeValues': attributeValues,
      'isActive': isActive,
      'isSearchable': isSearchable,
      'isFilterable': isFilterable,
      'isColorAttribute': isColorAttribute,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
