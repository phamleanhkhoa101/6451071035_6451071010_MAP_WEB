import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_review_model.dart';

class ProductReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = 'product_reviews';

  Future<void> create(ProductReviewModel model) async {
    await _db.collection(collection).add(model.toMap());
  }

  Future<void> update(ProductReviewModel model) async {
    await _db.collection(collection).doc(model.id).update(model.toMap());
  }

  Future<void> delete(String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  Stream<List<ProductReviewModel>> getAll() {
    return _db
        .collection(collection)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductReviewModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
