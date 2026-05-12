import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_review_controller.dart';
import '../../data/models/product_review_model.dart';
import '../../data/services/product_review_service.dart';
import '../shared/admin_ui.dart';

class AllReviewScreen extends StatefulWidget {
  const AllReviewScreen({super.key});

  @override
  State<AllReviewScreen> createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen> {
  final ProductReviewService _service = ProductReviewService();
  StreamSubscription<List<ProductReviewModel>>? _subscription;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _subscription = _service.getAll().listen((data) {
      if (!mounted) {
        return;
      }
      context.read<ProductReviewController>().setData(data);
      setState(() {
        _hasLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductReviewController>();

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
                    'Product Reviews',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2430),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Moderate customer reviews for phones and accessories.',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _openForm(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add review'),
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
                  hintText: 'Search by product, customer, comment or status...',
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
            InfoChip(label: 'Approved', value: '${controller.approvedCount}'),
            InfoChip(label: 'Pending', value: '${controller.pendingCount}'),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(child: AdminSectionCard(child: _buildBody(controller))),
      ],
    );
  }

  Widget _buildBody(ProductReviewController controller) {
    if (!_hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.filteredCount == 0) {
      return const Center(
        child: Text('No reviews available yet. Add or import a review first.'),
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
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Rating')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Comment')),
                  DataColumn(label: Text('Date')),
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
                      DataCell(
                        SizedBox(
                          width: 180,
                          child: Text(
                            item.productName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(width: 160, child: Text(item.customerName)),
                      ),
                      DataCell(_RatingStars(rating: item.rating)),
                      DataCell(
                        StatusPill(
                          label: item.status,
                          color: item.status == 'approved'
                              ? const Color(0xFF2E7D32)
                              : item.status == 'rejected'
                              ? const Color(0xFFB71C1C)
                              : const Color(0xFFEF6C00),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 320,
                          child: Text(
                            item.comment,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(Text(formatDate(item.createdAt))),
                      DataCell(
                        SizedBox(
                          width: 180,
                          child: Row(
                            children: [
                              OutlinedButton(
                                onPressed: () =>
                                    _openForm(context, review: item),
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
    ProductReviewModel? review,
  }) async {
    final productController = TextEditingController(
      text: review?.productName ?? '',
    );
    final customerController = TextEditingController(
      text: review?.customerName ?? '',
    );
    final commentController = TextEditingController(text: review?.comment ?? '');
    var rating = review?.rating ?? 5;
    var status = review?.status ?? 'pending';

    final model = await showDialog<ProductReviewModel>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(review == null ? 'Add review' : 'Edit review'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: productController,
                    decoration: const InputDecoration(labelText: 'Product'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: customerController,
                    decoration: const InputDecoration(labelText: 'Customer'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: rating,
                    decoration: const InputDecoration(labelText: 'Rating'),
                    items: List.generate(
                      5,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1} star'),
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => rating = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: 'approved',
                        child: Text('Approved'),
                      ),
                      DropdownMenuItem(
                        value: 'rejected',
                        child: Text('Rejected'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => status = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Comment'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final productName = productController.text.trim();
                final customerName = customerController.text.trim();
                if (productName.isEmpty || customerName.isEmpty) {
                  return;
                }

                Navigator.of(dialogContext).pop(
                  ProductReviewModel(
                    id: review?.id ?? '',
                    productName: productName,
                    customerName: customerName,
                    comment: commentController.text.trim(),
                    rating: rating,
                    status: status,
                    createdAt: review?.createdAt ?? DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                );
              },
              child: Text(review == null ? 'Create' : 'Save'),
            ),
          ],
        ),
      ),
    );

    productController.dispose();
    customerController.dispose();
    commentController.dispose();

    if (model == null || !context.mounted) {
      return;
    }

    final controller = context.read<ProductReviewController>();
    if (review == null) {
      await controller.create(model);
    } else {
      await controller.update(model);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ProductReviewModel review,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete review'),
        content: Text(
          'Are you sure you want to delete the review from "${review.customerName}"?',
        ),
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

    await context.read<ProductReviewController>().delete(review.id);
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 18,
          color: index < rating ? Colors.amber : Colors.grey,
        ),
      ),
    );
  }
}
