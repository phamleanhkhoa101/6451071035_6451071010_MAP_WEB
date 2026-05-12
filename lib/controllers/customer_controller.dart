import 'package:flutter/material.dart';

import '../data/models/customer_model.dart';
import '../data/services/customer_service.dart';

class CustomerController extends ChangeNotifier {
  CustomerController({CustomerService? service})
    : _service = service ?? CustomerService();

  final CustomerService _service;

  List<CustomerModel> _allData = [];
  List<CustomerModel> _filteredData = [];
  String _searchText = '';

  int currentPage = 0;
  int rowsPerPage = 5;

  int get totalCount => _allData.length;
  int get vipCount => _allData.where((item) => item.tier == 'vip').length;
  int get activeCount =>
      _allData.where((item) => item.status == 'active').length;
  int get filteredCount => _filteredData.length;
  int get totalPages =>
      _filteredData.isEmpty ? 1 : (_filteredData.length / rowsPerPage).ceil();
  bool get hasPreviousPage => currentPage > 0;
  bool get hasNextPage => currentPage < totalPages - 1;

  List<CustomerModel> get paginatedData {
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

  void setData(List<CustomerModel> data) {
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

  Future<void> create(CustomerModel model) async {
    await _service.create(model);
  }

  Future<void> update(CustomerModel model) async {
    await _service.update(model);
  }

  Future<void> delete(String id) async {
    await _service.delete(id);
  }

  void _applyFilter({required bool notify}) {
    if (_searchText.isEmpty) {
      _filteredData = List<CustomerModel>.from(_allData);
    } else {
      _filteredData = _allData.where((item) {
        return item.fullName.toLowerCase().contains(_searchText) ||
            item.email.toLowerCase().contains(_searchText) ||
            item.phone.toLowerCase().contains(_searchText) ||
            item.city.toLowerCase().contains(_searchText);
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
