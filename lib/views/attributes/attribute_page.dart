import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/attribute_controller.dart';
import '../../data/models/attribute_model.dart';
import '../../data/services/attribute_service.dart';
import 'attribute_add_edit_page.dart';

class AttributesPage extends StatefulWidget {
  const AttributesPage({super.key});

  @override
  State<AttributesPage> createState() => _AttributesPageState();
}

class _AttributesPageState extends State<AttributesPage> {
  final AttributeService _service = AttributeService();
  StreamSubscription<List<AttributeModel>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _service.getAll().listen((data) {
      if (!mounted) {
        return;
      }
      context.read<AttributeController>().setData(data);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AttributeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Attributes',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1B2430),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 360,
              child: TextField(
                onChanged: controller.search,
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên hoặc giá trị...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AttributeFormPage(),
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Thêm thuộc tính'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: controller.filteredCount == 0
                ? const Center(child: Text('Chưa có thuộc tính nào để hiển thị.'))
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFF1F5F9),
                            ),
                            columnSpacing: 24,
                            columns: const [
                              DataColumn(label: Text('SEQ')),
                              DataColumn(label: Text('Tên')),
                              DataColumn(label: Text('Giá trị')),
                              DataColumn(label: Text('Search')),
                              DataColumn(label: Text('Filter')),
                              DataColumn(label: Text('Color')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Updated')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: List.generate(
                              controller.paginatedData.length,
                              (index) {
                                final item = controller.paginatedData[index];
                                final rowNumber =
                                    (controller.currentPage * controller.rowsPerPage) +
                                    index +
                                    1;
                                return DataRow(
                                  cells: [
                                    DataCell(Text('$rowNumber')),
                                    DataCell(
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 220,
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: item.attributeValues
                                              .map(
                                                (value) => Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFE8F1FE),
                                                    borderRadius:
                                                        BorderRadius.circular(999),
                                                  ),
                                                  child: Text(
                                                    value,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    DataCell(_boolIcon(item.isSearchable)),
                                    DataCell(_boolIcon(item.isFilterable)),
                                    DataCell(_boolIcon(item.isColorAttribute)),
                                    DataCell(
                                      _statusBadge(item.isActive ? 'Active' : 'Inactive'),
                                    ),
                                    DataCell(Text(_formatDate(item.updatedAt))),
                                    DataCell(
                                      Wrap(
                                        spacing: 8,
                                        children: [
                                          OutlinedButton(
                                            onPressed: () => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => AttributeFormPage(
                                                  attribute: item,
                                                ),
                                              ),
                                            ),
                                            child: const Text('Sửa'),
                                          ),
                                          TextButton(
                                            onPressed: () => _confirmDelete(context, item),
                                            child: const Text('Xóa'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trang ${controller.currentPage + 1}/${controller.totalPages}',
                            style: const TextStyle(color: Color(0xFF64748B)),
                          ),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: controller.hasPreviousPage
                                    ? controller.previousPage
                                    : null,
                                child: const Text('Trước'),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.tonal(
                                onPressed: controller.hasNextPage
                                    ? controller.nextPage
                                    : null,
                                child: const Text('Sau'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AttributeModel attribute,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa thuộc tính'),
        content: Text('Bạn có chắc muốn xóa "${attribute.name}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    await context.read<AttributeController>().delete(attribute.id);
  }

  Widget _boolIcon(bool value) {
    return Icon(
      value ? Icons.check_circle_rounded : Icons.remove_circle_outline_rounded,
      color: value ? const Color(0xFF2E7D32) : const Color(0xFFB71C1C),
    );
  }

  Widget _statusBadge(String text) {
    final isActive = text == 'Active';
    final color = isActive ? const Color(0xFF2E7D32) : const Color(0xFFB71C1C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return '--';
    }

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }
}


