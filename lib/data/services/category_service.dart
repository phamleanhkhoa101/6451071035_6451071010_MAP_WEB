import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = 'categories';

  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _db
        .collection(collection)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => CategoryModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    final doc = _db.collection(collection).doc();
    await doc.set(category.copyWith(id: doc.id).toMap());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _db.collection(collection).doc(category.id).update(category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    await _db.collection(collection).doc(id).delete();
  }
}
