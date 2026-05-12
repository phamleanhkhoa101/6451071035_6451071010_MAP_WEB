import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_controller.dart';
import '../../data/models/product_model.dart';
import '../../data/services/product_service.dart';
import '../shared/admin_ui.dart';
import 'product_form_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService _service = ProductService();
  StreamSubscription<List<ProductModel>>? _subscription;
  bool _hasLoaded = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _subscription = _service.getAll().listen(
      (data) {
        if (!mounted) {
          return;
        }
        context.read<ProductController>().setData(data);
        setState(() {
          _hasLoaded = true;
          _errorMessage = null;
        });
      },
      onError: (Object error) {
        if (!mounted) {
          return;
        }
        setState(() {
          _hasLoaded = true;
          _errorMessage = error.toString();
        });
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductController>();

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
                    'Phone Products',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2430),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage the product catalog for your phone store.',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _openForm(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add product'),
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
                  hintText: 'Search by name, SKU, brand or category...',
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
            InfoChip(label: 'Total', value: '${controller.totalCount}'),
            InfoChip(label: 'Published', value: '${controller.activeCount}'),
            InfoChip(label: 'Featured', value: '${controller.featuredCount}'),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: AdminSectionCard(child: _buildBody(controller)),
        ),
      ],
    );
  }

  Widget _buildBody(ProductController controller) {
    if (!_hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          'Unable to load products.\n$_errorMessage',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (controller.filteredCount == 0) {
      return const Center(
        child: Text('No phone products found. Add your first item to begin.'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFFF1F5F9),
                ),
                columnSpacing: 24,
                horizontalMargin: 12,
                columns: const [
                  DataColumn(label: Text('SEQ')),
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Stock')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Updated')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: List.generate(controller.paginatedData.length, (index) {
                  final item = controller.paginatedData[index];
                  final rowNumber =
                      (controller.currentPage * controller.rowsPerPage) +
                      index +
                      1;
                  return DataRow(
                    cells: [
                      DataCell(Text('$rowNumber')),
                      DataCell(_ProductCell(product: item)),
                      DataCell(
                        SizedBox(
                          width: 180,
                          child: Text(
                            item.category.isEmpty ? '--' : item.category,
                          ),
                        ),
                      ),
                      DataCell(_PriceCell(product: item)),
                      DataCell(Text('${item.stock}')),
                      DataCell(
                        StatusPill(
                          label: item.status,
                          color: _statusColor(item.status),
                        ),
                      ),
                      DataCell(Text(formatDate(item.updatedAt))),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              OutlinedButton(
                                onPressed: () =>
                                    _openForm(context, product: item),
                                child: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => _confirmDelete(context, item),
                                child: const Text('Delete'),
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
        ),
        const SizedBox(height: 16),
        Pager(
          pageText:
              'Page ${controller.currentPage + 1}/${controller.totalPages}',
          hasPreviousPage: controller.hasPreviousPage,
          hasNextPage: controller.hasNextPage,
          onPrevious: controller.previousPage,
          onNext: controller.nextPage,
        ),
      ],
    );
  }

  Future<void> _openForm(
    BuildContext context, {
    ProductModel? product,
  }) async {
    final model = await showDialog<ProductModel>(
      context: context,
      builder: (_) => ProductFormPage(product: product),
    );

    if (model == null || !context.mounted) {
      return;
    }

    final controller = context.read<ProductController>();
    if (product == null) {
      await controller.create(model);
    } else {
      await controller.update(model);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ProductModel product,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete product'),
        content: Text('Are you sure you want to delete "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    await context.read<ProductController>().delete(product.id);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'published':
        return const Color(0xFF2E7D32);
      case 'archived':
        return const Color(0xFFB71C1C);
      default:
        return const Color(0xFFEF6C00);
    }
  }
}

class _ProductCell extends StatelessWidget {
  const _ProductCell({required this.product});

  final ProductModel product;

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
              child: product.imageUrl.isEmpty
                  ? const Icon(Icons.smartphone_rounded)
                  : Image.network(
                      product.imageUrl,
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
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${product.brand} | ${product.sku}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
    );
  }
}

class _PriceCell extends StatelessWidget {
  const _PriceCell({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatCurrency(product.price),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(
            product.originalPrice > 0
                ? formatCurrency(product.originalPrice)
                : '--',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
