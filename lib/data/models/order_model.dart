class OrderModel {
  OrderModel({
    required this.id,
    required this.customerName,
    required this.totalAmount,
  });

  final String id;
  final String customerName;
  final double totalAmount;
}
