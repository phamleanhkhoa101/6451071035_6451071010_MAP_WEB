import 'package:flutter/material.dart';

import '../data/models/category_model.dart';
import '../data/services/category_service.dart';

class CategoryController extends ChangeNotifier {
  final CategoryService _service;

  CategoryController({CategoryService? service})
    : _service = service ?? CategoryService();

  List<CategoryModel> _categories = [];
  List<CategoryModel> _filtered = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _currentQuery = '';

  // Phân trang
  int _currentPage = 1;
  final int _rowsPerPage = 6;

  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get filtered => _filtered;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;

  int get totalPages => (_filtered.length / _rowsPerPage).ceil();

  List<CategoryModel> get paginatedData {
    if (_filtered.isEmpty) return [];
    int startIndex = (_currentPage - 1) * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    if (endIndex > _filtered.length) {
      endIndex = _filtered.length;
    }
    if (startIndex >= _filtered.length) {
      return [];
    }
    return _filtered.sublist(startIndex, endIndex);
  }

  void changePage(int page) {
    if (page >= 1 && page <= totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _service.getCategories();
      _applySearch();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String keyword) {
    _currentQuery = keyword.trim().toLowerCase();
    _currentPage = 1; // Reset về trang 1 khi tìm kiếm
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_currentQuery.isEmpty) {
      _filtered = List<CategoryModel>.from(_categories);
    } else {
      _filtered = _categories.where((category) {
        return category.name.toLowerCase().contains(_currentQuery);
      }).toList();
    }
    // Sắp xếp các danh mục nổi bật lên trên, sau đó theo tên
    _filtered.sort((a, b) {
      if (a.isFeatured && !b.isFeatured) return -1;
      if (!a.isFeatured && b.isFeatured) return 1;
      return a.name.compareTo(b.name);
    });
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
