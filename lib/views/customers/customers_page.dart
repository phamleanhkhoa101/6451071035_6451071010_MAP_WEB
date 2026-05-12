import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/customer_controller.dart';
import '../../data/models/customer_model.dart';
import '../../data/services/customer_service.dart';
import '../shared/admin_ui.dart';
import 'customer_detail_page.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final CustomerService _service = CustomerService();
  StreamSubscription<List<CustomerModel>>? _subscription;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _subscription = _service.getAll().listen((data) {
      if (!mounted) {
        return;
      }
      context.read<CustomerController>().setData(data);
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
    final controller = context.watch<CustomerController>();

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
                    'Customers',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2430),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage buyer profiles and loyalty tiers.',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _openForm(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add customer'),
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
                  hintText: 'Search by name, email, phone or city...',
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
            InfoChip(label: 'VIP', value: '${controller.vipCount}'),
            InfoChip(label: 'Active', value: '${controller.activeCount}'),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(child: AdminSectionCard(child: _buildBody(controller))),
      ],
    );
  }

  Widget _buildBody(CustomerController controller) {
    if (!_hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.filteredCount == 0) {
      return const Center(
        child: Text('No customers found. Add a customer profile to begin.'),
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
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Contact')),
                  DataColumn(label: Text('Tier')),
                  DataColumn(label: Text('Orders')),
                  DataColumn(label: Text('Spent')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Joined')),
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
                          width: 220,
                          child: Text(
                            item.fullName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.email),
                              Text(
                                item.phone,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(Text(item.tier)),
                      DataCell(Text('${item.totalOrders}')),
                      DataCell(Text(formatCurrency(item.totalSpent))),
                      DataCell(
                        StatusPill(
                          label: item.status,
                          color: item.status == 'active'
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFB71C1C),
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
                                onPressed: () =>
                                    _openForm(context, customer: item),
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

  Future<void> _showDetails(
    BuildContext context,
    CustomerModel customer,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => CustomerDetailPage(customer: customer),
    );
  }

  Future<void> _openForm(
    BuildContext context, {
    CustomerModel? customer,
  }) async {
    final nameController = TextEditingController(
      text: customer?.fullName ?? '',
    );
    final emailController = TextEditingController(text: customer?.email ?? '');
    final phoneController = TextEditingController(text: customer?.phone ?? '');
    final cityController = TextEditingController(text: customer?.city ?? '');
    final ordersController = TextEditingController(
      text: customer == null ? '' : '${customer.totalOrders}',
    );
    final spentController = TextEditingController(
      text: customer == null ? '' : customer.totalSpent.toStringAsFixed(0),
    );
    var tier = customer?.tier ?? 'standard';
    var status = customer?.status ?? 'active';

    final model = await showDialog<CustomerModel>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(customer == null ? 'Add customer' : 'Edit customer'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Full name'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
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
                    controller: cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: tier,
                          decoration: const InputDecoration(labelText: 'Tier'),
                          items: const [
                            DropdownMenuItem(
                              value: 'standard',
                              child: Text('Standard'),
                            ),
                            DropdownMenuItem(
                              value: 'vip',
                              child: Text('VIP'),
                            ),
                            DropdownMenuItem(
                              value: 'wholesale',
                              child: Text('Wholesale'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => tier = value);
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
                              value: 'active',
                              child: Text('Active'),
                            ),
                            DropdownMenuItem(
                              value: 'inactive',
                              child: Text('Inactive'),
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
                          controller: ordersController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Total orders',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: spentController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Total spent',
                          ),
                        ),
                      ),
                    ],
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
                final fullName = nameController.text.trim();
                if (fullName.isEmpty) {
                  return;
                }

                Navigator.of(dialogContext).pop(
                  CustomerModel(
                    id: customer?.id ?? '',
                    fullName: fullName,
                    email: emailController.text.trim(),
                    phone: phoneController.text.trim(),
                    city: cityController.text.trim(),
                    tier: tier,
                    status: status,
                    totalOrders:
                        int.tryParse(ordersController.text.trim()) ?? 0,
                    totalSpent:
                        double.tryParse(spentController.text.trim()) ?? 0,
                    createdAt: customer?.createdAt ?? DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                );
              },
              child: Text(customer == null ? 'Create' : 'Save'),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    ordersController.dispose();
    spentController.dispose();

    if (model == null || !context.mounted) {
      return;
    }

    final controller = context.read<CustomerController>();
    if (customer == null) {
      await controller.create(model);
    } else {
      await controller.update(model);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    CustomerModel customer,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete customer'),
        content: Text(
          'Are you sure you want to delete "${customer.fullName}"?',
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

    await context.read<CustomerController>().delete(customer.id);
  }
}
