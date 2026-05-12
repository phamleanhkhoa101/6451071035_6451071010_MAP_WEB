import 'package:flutter/material.dart';

import '../data/models/category_model.dart';
import '../data/services/category_service.dart';

class CategoryController extends ChangeNotifier {
  CategoryController({CategoryService? service})
    : _service = service ?? CategoryService();

  final CategoryService _service;

  List<CategoryModel> categories = [];
  List<CategoryModel> filtered = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchCategories() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      categories = await _service.getCategories();
      filtered = List<CategoryModel>.from(categories);
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void search(String keyword) {
    final query = keyword.trim().toLowerCase();
    if (query.isEmpty) {
      filtered = List<CategoryModel>.from(categories);
    } else {
      filtered = categories.where((category) {
        return category.name.toLowerCase().contains(query);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> add(CategoryModel category) async {
    await _service.addCategory(category);
    await fetchCategories();
  }

  Future<void> update(CategoryModel category) async {
    await _service.updateCategory(category);
    await fetchCategories();
  }

  Future<void> delete(String id) async {
    await _service.deleteCategory(id);
    await fetchCategories();
  }
}
