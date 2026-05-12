import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/category_controller.dart';
import '../../data/models/category_model.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryController>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CategoryController>();

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
                    'Product Categories',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2430),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quản lý danh mục sản phẩm theo mục 4 của tài liệu.',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _showDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Thêm danh mục'),
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
              width: 340,
              child: TextField(
                onChanged: controller.search,
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên danh mục...',
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
            _InfoChip(
              label: 'Tổng số',
              value: '${controller.categories.length}',
            ),
            _InfoChip(
              label: 'Hiển thị',
              value: '${controller.filtered.length}',
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
            child: _buildBody(context, controller),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, CategoryController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Text(
          'Không tải được dữ liệu.\n${controller.errorMessage}',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (controller.filtered.isEmpty) {
      return const Center(
        child: Text('Chưa có danh mục nào hoặc không khớp từ khóa tìm kiếm.'),
      );
    }

    return SingleChildScrollView(
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
        columnSpacing: 28,
        horizontalMargin: 12,
        columns: const [
          DataColumn(label: Text('Danh mục')),
          DataColumn(label: Text('Trạng thái')),
          DataColumn(label: Text('Nổi bật')),
          DataColumn(label: Text('Số SP')),
          DataColumn(label: Text('Cập nhật')),
          DataColumn(label: Text('Thao tác')),
        ],
        rows: controller.filtered.map((category) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 52,
                        height: 52,
                        color: const Color(0xFFE2E8F0),
                        child: category.imageURL.isEmpty
                            ? const Icon(Icons.image_not_supported_outlined)
                            : Image.network(
                                category.imageURL,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Icon(
                                  Icons.broken_image_outlined,
                                ),
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
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            category.createdBy.isEmpty
                                ? 'Tạo bởi admin'
                                : 'Tạo bởi ${category.createdBy}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(_StatusBadge(
                text: category.isActive ? 'Active' : 'Inactive',
                color: category.isActive
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFB71C1C),
              )),
              DataCell(
                Icon(
                  category.isFeatured
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: category.isFeatured ? Colors.amber : Colors.grey,
                ),
              ),
              DataCell(Text('${category.numberOfProducts}')),
              DataCell(Text(_formatDate(category.updatedAt))),
              DataCell(
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () => _showDialog(context, category: category),
                      child: const Text('Sửa'),
                    ),
                    TextButton(
                      onPressed: () => _confirmDelete(context, category),
                      child: const Text('Xóa'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    CategoryModel category,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa danh mục'),
        content: Text('Bạn có chắc muốn xóa "${category.name}" không?'),
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

    await context.read<CategoryController>().delete(category.id);
  }

  void _showDialog(BuildContext context, {CategoryModel? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final imageController = TextEditingController(
      text: category?.imageURL ?? '',
    );
    var isActive = category?.isActive ?? true;
    var isFeatured = category?.isFeatured ?? false;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(category == null ? 'Thêm danh mục' : 'Cập nhật danh mục'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên danh mục',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                    ),
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

                final newCategory = CategoryModel(
                  id: category?.id ?? '',
                  name: trimmedName,
                  imageURL: imageController.text.trim(),
                  isActive: isActive,
                  isFeatured: isFeatured,
                  priority: category?.priority ?? 0,
                  numberOfProducts: category?.numberOfProducts ?? 0,
                  viewCount: category?.viewCount ?? 0,
                  createdBy: category?.createdBy ?? 'admin',
                  updatedBy: 'admin',
                  createdAt: category?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                final controller = context.read<CategoryController>();
                if (category == null) {
                  await controller.add(newCategory);
                } else {
                  await controller.update(newCategory);
                }

                if (!dialogContext.mounted) {
                  return;
                }

                Navigator.of(dialogContext).pop();
              },
              child: Text(category == null ? 'Thêm' : 'Lưu'),
            ),
          ],
        ),
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
          Text(
            label,
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
