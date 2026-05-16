import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String docId;
  final String id;
  final String userId;

  final List<dynamic> products;

  final double subTotal;
  final double taxAmount;
  final double taxRate;
  final double shippingAmount;

  final double totalDiscountAmount;
  final double couponDiscountAmount;
  final double totalAmount;

  final String paymentStatus;
  final String orderStatus;

  final String paymentMethod;
  final String paymentMethodType;

  final int itemCount;

  final DateTime orderDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? shippingDate;

  final Map<String, dynamic> shippingAddress;

  // 👇 Admin list helper fields
  String customerName;

  OrderModel({
    required this.docId,
    required this.id,
    required this.userId,
    required this.products,
    required this.subTotal,
    required this.taxAmount,
    required this.taxRate,
    required this.shippingAmount,
    required this.totalDiscountAmount,
    required this.couponDiscountAmount,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.paymentMethod,
    required this.paymentMethodType,
    required this.itemCount,
    required this.orderDate,
    required this.createdAt,
    required this.updatedAt,
    required this.shippingAddress,
    this.shippingDate,
    this.customerName = '',
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      docId: doc.id,
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      products: data['products'] ?? [],
      subTotal: _parseDouble(data['subTotal']),
      taxAmount: _parseDouble(data['taxAmount']),
      taxRate: _parseDouble(data['taxRate']),
      shippingAmount: _parseDouble(data['shippingAmount']),
      totalDiscountAmount: _parseDouble(data['totalDiscountAmount']),
      couponDiscountAmount: _parseDouble(data['couponDiscountAmount']),
      totalAmount: _parseDouble(data['totalAmount']),
      paymentStatus: data['paymentStatus'] ?? '',
      orderStatus: data['orderStatus'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      paymentMethodType: data['paymentMethodType'] ?? '',
      itemCount: (data['itemCount'] is num) ? (data['itemCount'] as num).toInt() : (int.tryParse(data['itemCount']?.toString() ?? '') ?? 0),
      orderDate: data['orderDate'] != null ? (data['orderDate'] as Timestamp).toDate() : DateTime.now(),
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : DateTime.now(),
      shippingDate: data['shippingDate'] != null ? (data['shippingDate'] as Timestamp).toDate() : null,
      shippingAddress: data['shippingAddress'] ?? {},
    );
  }
}
