import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/customer_model.dart';

class CustomerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = 'customers';

  Future<void> create(CustomerModel model) async {
    await _db.collection(collection).add(model.toMap());
  }

  Future<void> update(CustomerModel model) async {
    await _db.collection(collection).doc(model.id).update(model.toMap());
  }

  Future<void> delete(String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  Stream<List<CustomerModel>> getAll() {
    return _db
        .collection(collection)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CustomerModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
