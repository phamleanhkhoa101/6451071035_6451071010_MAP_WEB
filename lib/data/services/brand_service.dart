import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/brand_model.dart';

class BrandService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = 'brands';

  Future<void> create(BrandModel model) async {
    await _db.collection(collection).add(model.toMap());
  }

  Future<void> update(BrandModel model) async {
    await _db.collection(collection).doc(model.id).update(model.toMap());
  }

  Future<void> delete(String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  Stream<List<BrandModel>> getAll() {
    return _db
        .collection(collection)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BrandModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
