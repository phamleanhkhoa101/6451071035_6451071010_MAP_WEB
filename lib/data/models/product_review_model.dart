class ProductReviewModel {
  ProductReviewModel({
    required this.id,
    required this.customerName,
    required this.comment,
    this.rating = 0,
  });

  final String id;
  final String customerName;
  final String comment;
  final int rating;
}
