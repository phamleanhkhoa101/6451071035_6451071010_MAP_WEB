import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  OrderModel({
    required this.id,
    required this.orderCode,
    required this.customerName,
    required this.customerPhone,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.status,
    required this.itemsCount,
    required this.totalAmount,
    required this.note,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String orderCode;
  final String customerName;
  final String customerPhone;
  final String shippingAddress;
  final String paymentMethod;
  final String status;
  final int itemsCount;
  final double totalAmount;
  final String note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      orderCode: _toStringValue(
        map['orderCode'] ?? map['code'],
        preferredKeys: const ['code', 'id', 'value'],
      ),
      customerName: _toStringValue(
        map['customerName'] ?? map['customer'],
        preferredKeys: const ['fullName', 'name', 'displayName'],
      ),
      customerPhone: _toStringValue(
        map['customerPhone'] ?? map['customer'],
        preferredKeys: const ['phone', 'mobile', 'phoneNumber'],
      ),
      shippingAddress: _toStringValue(
        map['shippingAddress'] ?? map['address'],
        preferredKeys: const [
          'fullAddress',
          'address',
          'street',
          'district',
          'city',
        ],
      ),
      paymentMethod: _toStringValue(
        map['paymentMethod'],
        preferredKeys: const ['name', 'method', 'type', 'label'],
      ),
      status: _normalizeStatus(map['status']),
      itemsCount: _toInt(
        map['itemsCount'] ??
            (map['items'] is List ? (map['items'] as List).length : null),
      ),
      totalAmount: _toDouble(
        map['totalAmount'] ??
            map['total'] ??
            (map['summary'] is Map
                ? Map<String, dynamic>.from(map['summary'] as Map)['total']
                : null),
      ),
      note: _toStringValue(
        map['note'],
        preferredKeys: const ['message', 'content', 'text'],
      ),
      createdAt: _toDate(map['createdAt']),
      updatedAt: _toDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderCode': orderCode,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'status': status,
      'itemsCount': itemsCount,
      'totalAmount': totalAmount,
      'note': note,
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

  static String _normalizeStatus(dynamic value) {
    final raw = _toStringValue(
      value,
      preferredKeys: const ['label', 'value', 'status'],
    ).toLowerCase();

    if (raw.contains('deliver')) {
      return 'delivered';
    }
    if (raw.contains('ship')) {
      return 'shipping';
    }
    if (raw.contains('cancel')) {
      return 'cancelled';
    }
    if (raw.contains('pend')) {
      return 'pending';
    }
    return raw.isEmpty ? 'pending' : raw;
  }

  static String _toStringValue(
    dynamic value, {
    List<String> preferredKeys = const [],
  }) {
    if (value == null) {
      return '';
    }
    if (value is String) {
      return value;
    }
    if (value is num || value is bool) {
      return value.toString();
    }
    if (value is Map) {
      final mapped = Map<String, dynamic>.from(value);
      for (final key in preferredKeys) {
        final candidate = _toStringValue(mapped[key]);
        if (candidate.isNotEmpty) {
          return candidate;
        }
      }

      final parts = mapped.values
          .map((item) => _toStringValue(item))
          .where((item) => item.isNotEmpty)
          .toList();
      return parts.join(', ');
    }
    if (value is List) {
      return value
          .map((item) => _toStringValue(item))
          .where((item) => item.isNotEmpty)
          .join(', ');
    }
    return value.toString();
  }
}
