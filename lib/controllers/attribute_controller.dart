import 'package:flutter/material.dart';

import '../data/models/attribute_model.dart';
import '../data/services/attribute_service.dart';

class AttributeController extends ChangeNotifier {
  AttributeController({AttributeService? service})
    : _service = service ?? AttributeService();

  final AttributeService _service;

  List<AttributeModel> _allData = [];
  List<AttributeModel> _filteredData = [];
  String _searchText = '';

  int currentPage = 0;
  int rowsPerPage = 5;

  int get totalCount => _allData.length;
  int get filteredCount => _filteredData.length;
  int get activeCount => _allData.where((item) => item.isActive).length;
  int get searchableCount => _allData.where((item) => item.isSearchable).length;
  int get filterableCount => _allData.where((item) => item.isFilterable).length;
  int get colorAttributeCount =>
      _allData.where((item) => item.isColorAttribute).length;
  int get totalPages =>
      _filteredData.isEmpty ? 1 : (_filteredData.length / rowsPerPage).ceil();
  bool get hasPreviousPage => currentPage > 0;
  bool get hasNextPage => currentPage < totalPages - 1;

  List<AttributeModel> get paginatedData {
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

  void setData(List<AttributeModel> data) {
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

  Future<void> create(AttributeModel model) async {
    await _service.create(model);
  }

  Future<void> update(AttributeModel model) async {
    await _service.update(model);
  }

  Future<void> delete(String id) async {
    await _service.delete(id);
  }

  void _applyFilter({required bool notify}) {
    if (_searchText.isEmpty) {
      _filteredData = List<AttributeModel>.from(_allData);
    } else {
      _filteredData = _allData.where((item) {
        return item.name.toLowerCase().contains(_searchText) ||
            item.attributeValues.join(' ').toLowerCase().contains(_searchText);
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
