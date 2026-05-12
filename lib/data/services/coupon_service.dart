import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/coupon_model.dart';

class CouponService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = 'coupons';

  Future<void> create(CouponModel model) async {
    await _db.collection(collection).add(model.toMap());
  }

  Future<void> update(CouponModel model) async {
    await _db.collection(collection).doc(model.id).update(model.toMap());
  }

  Future<void> delete(String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  Stream<List<CouponModel>> getAll() {
    return _db
        .collection(collection)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CouponModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
