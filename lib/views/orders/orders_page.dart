import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/order_controller.dart';
import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';
import '../shared/admin_ui.dart';
import 'order_detail_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderService _service = OrderService();
  StreamSubscription<List<OrderModel>>? _subscription;
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
        context.read<OrderController>().setData(data);
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
    final controller = context.watch<OrderController>();

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
                    'Orders',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2430),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Track phone orders and update their delivery status.',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _openForm(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add manual order'),
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
                  hintText: 'Search by code, customer, phone or status...',
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
            InfoChip(label: 'Pending', value: '${controller.pendingCount}'),
            InfoChip(label: 'Shipping', value: '${controller.shippingCount}'),
            InfoChip(label: 'Delivered', value: '${controller.deliveredCount}'),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(child: AdminSectionCard(child: _buildBody(controller))),
      ],
    );
  }

  Widget _buildBody(OrderController controller) {
    if (!_hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          'Unable to load orders.\n$_errorMessage',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (controller.filteredCount == 0) {
      return const Center(
        child: Text('No orders found. Manual orders can be created here.'),
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
                  DataColumn(label: Text('Order')),
                  DataColumn(label: Text('Payment')),
                  DataColumn(label: Text('Items')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Created')),
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
                      DataCell(_OrderCell(order: item)),
                      DataCell(
                        SizedBox(
                          width: 120,
                          child: Text(item.paymentMethod),
                        ),
                      ),
                      DataCell(Text('${item.itemsCount}')),
                      DataCell(Text(formatCurrency(item.totalAmount))),
                      DataCell(
                        StatusPill(
                          label: item.status,
                          color: _statusColor(item.status),
                        ),
                      ),
                      DataCell(Text(formatDate(item.createdAt))),
                      DataCell(
                        SizedBox(
                          width: 270,
                          child: Row(
                            children: [
                              OutlinedButton(
                                onPressed: () => _showDetails(context, item),
                                child: const Text('Details'),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.tonal(
                                onPressed: () => _openForm(context, order: item),
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

  Future<void> _showDetails(BuildContext context, OrderModel order) async {
    await showDialog<void>(
      context: context,
      builder: (_) => OrderDetailPage(order: order),
    );
  }

  Future<void> _openForm(
    BuildContext context, {
    OrderModel? order,
  }) async {
    final codeController = TextEditingController(text: order?.orderCode ?? '');
    final nameController = TextEditingController(
      text: order?.customerName ?? '',
    );
    final phoneController = TextEditingController(
      text: order?.customerPhone ?? '',
    );
    final addressController = TextEditingController(
      text: order?.shippingAddress ?? '',
    );
    final itemsController = TextEditingController(
      text: order == null ? '' : '${order.itemsCount}',
    );
    final totalController = TextEditingController(
      text: order == null ? '' : order.totalAmount.toStringAsFixed(0),
    );
    final noteController = TextEditingController(text: order?.note ?? '');
    var paymentMethod = order?.paymentMethod ?? 'COD';
    var status = order?.status ?? 'pending';

    final model = await showDialog<OrderModel>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(order == null ? 'Add order' : 'Edit order'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'Order code'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Customer name',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: paymentMethod,
                          decoration: const InputDecoration(
                            labelText: 'Payment method',
                          ),
                          items: const [
                            DropdownMenuItem(value: 'COD', child: Text('COD')),
                            DropdownMenuItem(
                              value: 'Bank transfer',
                              child: Text('Bank transfer'),
                            ),
                            DropdownMenuItem(
                              value: 'Card',
                              child: Text('Card'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => paymentMethod = value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: status,
                          decoration: const InputDecoration(labelText: 'Status'),
                          items: const [
                            DropdownMenuItem(
                              value: 'pending',
                              child: Text('Pending'),
                            ),
                            DropdownMenuItem(
                              value: 'shipping',
                              child: Text('Shipping'),
                            ),
                            DropdownMenuItem(
                              value: 'delivered',
                              child: Text('Delivered'),
                            ),
                            DropdownMenuItem(
                              value: 'cancelled',
                              child: Text('Cancelled'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => status = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: itemsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Items'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: totalController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Total'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Note'),
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
                final code = codeController.text.trim();
                final customerName = nameController.text.trim();
                if (code.isEmpty || customerName.isEmpty) {
                  return;
                }

                Navigator.of(dialogContext).pop(
                  OrderModel(
                    id: order?.id ?? '',
                    orderCode: code,
                    customerName: customerName,
                    customerPhone: phoneController.text.trim(),
                    shippingAddress: addressController.text.trim(),
                    paymentMethod: paymentMethod,
                    status: status,
                    itemsCount: int.tryParse(itemsController.text.trim()) ?? 0,
                    totalAmount:
                        double.tryParse(totalController.text.trim()) ?? 0,
                    note: noteController.text.trim(),
                    createdAt: order?.createdAt ?? DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                );
              },
              child: Text(order == null ? 'Create' : 'Save'),
            ),
          ],
        ),
      ),
    );

    codeController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    itemsController.dispose();
    totalController.dispose();
    noteController.dispose();

    if (model == null || !context.mounted) {
      return;
    }

    final controller = context.read<OrderController>();
    if (order == null) {
      await controller.create(model);
    } else {
      await controller.update(model);
    }
  }

  Future<void> _confirmDelete(BuildContext context, OrderModel order) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete order'),
        content: Text(
          'Are you sure you want to delete order "${order.orderCode}"?',
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

    await context.read<OrderController>().delete(order.id);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'delivered':
        return const Color(0xFF2E7D32);
      case 'shipping':
        return const Color(0xFF1565C0);
      case 'cancelled':
        return const Color(0xFFB71C1C);
      default:
        return const Color(0xFFEF6C00);
    }
  }
}

class _OrderCell extends StatelessWidget {
  const _OrderCell({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.orderCode,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          Text(
            '${order.customerName} | ${order.customerPhone}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
