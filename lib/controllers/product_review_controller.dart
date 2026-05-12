import 'package:flutter/material.dart';

import '../data/models/product_review_model.dart';
import '../data/services/product_review_service.dart';

class ProductReviewController extends ChangeNotifier {
  ProductReviewController({ProductReviewService? service})
    : _service = service ?? ProductReviewService();

  final ProductReviewService _service;

  List<ProductReviewModel> _allData = [];
  List<ProductReviewModel> _filteredData = [];
  String _searchText = '';

  int currentPage = 0;
  int rowsPerPage = 5;

  int get totalCount => _allData.length;
  int get approvedCount =>
      _allData.where((item) => item.status == 'approved').length;
  int get pendingCount =>
      _allData.where((item) => item.status == 'pending').length;
  int get filteredCount => _filteredData.length;
  int get totalPages =>
      _filteredData.isEmpty ? 1 : (_filteredData.length / rowsPerPage).ceil();
  bool get hasPreviousPage => currentPage > 0;
  bool get hasNextPage => currentPage < totalPages - 1;

  List<ProductReviewModel> get paginatedData {
    if (_filteredData.isEmpty) {
      return [];
    }

    final start = currentPage * rowsPerPage;
    final end = start + rowsPerPage;
    return _filteredData.sublist(
      start,
      end > _filteredData.length ? _filteredData.length : end,
    );
  }

  void setData(List<ProductReviewModel> data) {
    _allData = data;
    _applyFilter(notify: true);
  }

  void search(String value) {
    _searchText = value.trim().toLowerCase();
    currentPage = 0;
    _applyFilter(notify: true);
  }

  void previousPage() {
    if (!hasPreviousPage) {
      return;
    }
    currentPage--;
    notifyListeners();
  }

  void nextPage() {
    if (!hasNextPage) {
      return;
    }
    currentPage++;
    notifyListeners();
  }

  Future<void> create(ProductReviewModel model) async {
    await _service.create(model);
  }

  Future<void> update(ProductReviewModel model) async {
    await _service.update(model);
  }

  Future<void> delete(String id) async {
    await _service.delete(id);
  }

  void _applyFilter({required bool notify}) {
    if (_searchText.isEmpty) {
      _filteredData = List<ProductReviewModel>.from(_allData);
    } else {
      _filteredData = _allData.where((item) {
        return item.productName.toLowerCase().contains(_searchText) ||
            item.customerName.toLowerCase().contains(_searchText) ||
            item.comment.toLowerCase().contains(_searchText) ||
            item.status.toLowerCase().contains(_searchText);
      }).toList();
    }

    if (currentPage >= totalPages) {
      currentPage = totalPages - 1;
    }
    if (currentPage < 0) {
      currentPage = 0;
    }

    if (notify) {
      notifyListeners();
    }
  }
}
