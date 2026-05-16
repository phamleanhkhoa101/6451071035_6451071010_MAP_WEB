import 'package:flutter/material.dart';

import '../data/models/customer_model.dart';
import '../data/services/customer_service.dart';

class CustomerController extends ChangeNotifier {
  final CustomerService _service = CustomerService();

  List<CustomerModel> _allData = [];
  List<CustomerModel> _filteredData = [];
  String _searchText = '';

  bool isLoading = false;

  int currentPage = 1;
  int rowsPerPage = 10;

  Map<String, int> orderCountMap = {};

  int get totalPages {
    if (_filteredData.isEmpty) return 1;
    return (_filteredData.length / rowsPerPage).ceil();
  }

  List<CustomerModel> get paginatedData {
    if (_filteredData.isEmpty) return [];

    final start = (currentPage - 1) * rowsPerPage;
    final end = start + rowsPerPage;
    return _filteredData.sublist(
      start,
      end > _filteredData.length ? _filteredData.length : end,
    );
  }

  Future<void> fetchCustomers() async {
    isLoading = true;
    notifyListeners();

    try {
      _allData = await _service.getCustomers();
      for (var c in _allData) {
        orderCountMap[c.id] = await _service.getOrdersCount(c.id);
      }
      _filteredData = List.from(_allData);
    } catch (e) {
      print("Error fetching customers: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void search(String value) {
    _searchText = value.trim().toLowerCase();
    currentPage = 1;
    
    if (_searchText.isEmpty) {
      _filteredData = List.from(_allData);
    } else {
      _filteredData = _allData.where((item) {
        return item.fullName.toLowerCase().contains(_searchText) ||
            item.email.toLowerCase().contains(_searchText) ||
            item.phone.toLowerCase().contains(_searchText);
      }).toList();
    }
    
    notifyListeners();
  }

  void changePage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage = page;
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    await _service.deleteCustomer(id);
    _allData.removeWhere((c) => c.id == id);
    _filteredData.removeWhere((c) => c.id == id);
    
    // adjust current page if out of bounds
    if (currentPage > totalPages) {
      currentPage = totalPages;
    }
    if (currentPage < 1) {
      currentPage = 1;
    }
    
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getOrders(String customerId) async {
    return await _service.getOrdersOfUser(customerId);
  }
}
