import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/brand_controller.dart';
import '../../data/models/brand_model.dart';
import '../../data/services/brand_service.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  final BrandService _service = BrandService();
  StreamSubscription<List<BrandModel>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _service.getAll().listen((data) {
      if (!mounted) {
        return;
      }
      context.read<BrandController>().setData(data);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BrandController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Brands',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2430),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _showDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Thêm thương hiệu'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 360,
              child: TextField(
                onChanged: controller.search,
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên hoặc mô tả...',
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
            _InfoChip(label: 'Tổng số', value: '${controller.totalCount}'),
            _InfoChip(label: 'Hiển thị', value: '${controller.filteredCount}'),
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
                ? const Center(child: Text('Chưa có thương hiệu nào để hiển thị.'))
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFF1F5F9),
                            ),
                            columnSpacing: 28,
                            horizontalMargin: 12,
                            columns: const [
                              DataColumn(label: Text('SEQ')),
                              DataColumn(label: Text('Thương hiệu')),
                              DataColumn(label: Text('Ưu tiên')),
                              DataColumn(label: Text('Nổi bật')),
                              DataColumn(label: Text('Trạng thái')),
                              DataColumn(label: Text('Cập nhật')),
                              DataColumn(label: Text('Thao tác')),
                            ],
                            rows: List.generate(controller.paginatedData.length, (
                              index,
                            ) {
                              final item = controller.paginatedData[index];
                              final rowNumber =
                                  (controller.currentPage *
                                      controller.rowsPerPage) +
                                  index +
                                  1;
                              return DataRow(
                                cells: [
                                  DataCell(Text('$rowNumber')),
                                  DataCell(_BrandCell(brand: item)),
                                  DataCell(Text('${item.priority}')),
                                  DataCell(_boolIcon(item.isFeatured)),
                                  DataCell(_StatusBadge(active: item.isActive)),
                                  DataCell(Text(_formatDate(item.updatedAt))),
                                  DataCell(
                                    SizedBox(
                                      width: 150,
                                      child: Row(
                                        children: [
                                          OutlinedButton(
                                            onPressed: () => _showDialog(
                                              context,
                                              brand: item,
                                            ),
                                            child: const Text('Sửa'),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton(
                                            onPressed: () =>
                                                _confirmDelete(context, item),
                                            child: const Text('Xóa'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _Pager(
                        pageText:
                            'Trang ${controller.currentPage + 1}/${controller.totalPages}',
                        hasPreviousPage: controller.hasPreviousPage,
                        hasNextPage: controller.hasNextPage,
                        onPrevious: controller.previousPage,
                        onNext: controller.nextPage,
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, BrandModel brand) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa thương hiệu'),
        content: Text('Bạn có chắc muốn xóa "${brand.name}" không?'),
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

    await context.read<BrandController>().delete(brand.id);
  }

  void _showDialog(BuildContext context, {BrandModel? brand}) {
    final nameController = TextEditingController(text: brand?.name ?? '');
    final logoController = TextEditingController(text: brand?.logoUrl ?? '');
    final descriptionController = TextEditingController(
      text: brand?.description ?? '',
    );
    final priorityController = TextEditingController(
      text: '${brand?.priority ?? 0}',
    );
    var isActive = brand?.isActive ?? true;
    var isFeatured = brand?.isFeatured ?? false;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(brand == null ? 'Thêm thương hiệu' : 'Cập nhật thương hiệu'),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Tên thương hiệu'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: logoController,
                    decoration: const InputDecoration(labelText: 'Logo URL'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Mô tả'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priorityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Thứ tự ưu tiên'),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isActive,
                    title: const Text('Kích hoạt'),
                    onChanged: (value) => setState(() => isActive = value),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isFeatured,
                    title: const Text('Nổi bật'),
                    onChanged: (value) => setState(() => isFeatured = value),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () async {
                final trimmedName = nameController.text.trim();
                if (trimmedName.isEmpty) {
                  return;
                }

                final model = BrandModel(
                  id: brand?.id ?? '',
                  name: trimmedName,
                  logoUrl: logoController.text.trim(),
                  description: descriptionController.text.trim(),
                  isActive: isActive,
                  isFeatured: isFeatured,
                  priority: int.tryParse(priorityController.text.trim()) ?? 0,
                  createdAt: brand?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                final controller = context.read<BrandController>();
                if (brand == null) {
                  await controller.create(model);
                } else {
                  await controller.update(model);
                }

                if (!dialogContext.mounted) {
                  return;
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(brand == null ? 'Thêm' : 'Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boolIcon(bool value) {
    return Icon(
      value ? Icons.star_rounded : Icons.star_outline_rounded,
      color: value ? Colors.amber : Colors.grey,
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

class _BrandCell extends StatelessWidget {
  const _BrandCell({required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 52,
              height: 52,
              color: const Color(0xFFE2E8F0),
              child: brand.logoUrl.isEmpty
                  ? const Icon(Icons.branding_watermark_outlined)
                  : Image.network(
                      brand.logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  brand.description.isEmpty ? 'Chưa có mô tả' : brand.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF2E7D32) : const Color(0xFFB71C1C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Pager extends StatelessWidget {
  const _Pager({
    required this.pageText,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.onPrevious,
    required this.onNext,
  });

  final String pageText;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(pageText, style: const TextStyle(color: Color(0xFF64748B))),
        Row(
          children: [
            OutlinedButton(
              onPressed: hasPreviousPage ? onPrevious : null,
              child: const Text('Trước'),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: hasNextPage ? onNext : null,
              child: const Text('Sau'),
            ),
          ],
        ),
      ],
    );
  }
}


