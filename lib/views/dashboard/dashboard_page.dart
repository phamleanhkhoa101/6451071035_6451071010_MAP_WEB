import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/attribute_controller.dart';
import '../../controllers/category_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryController>().categories.length;
    final attributes = context.watch<AttributeController>().totalCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1B2430),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Tổng quan nhanh các nhóm chức năng đã hoàn thành đến mục 5.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _StatCard(
              title: 'Danh mục sản phẩm',
              value: '$categories',
              icon: Icons.category_outlined,
              color: const Color(0xFF1976D2),
            ),
            _StatCard(
              title: 'Thuộc tính sản phẩm',
              value: '$attributes',
              icon: Icons.tune_rounded,
              color: const Color(0xFF00897B),
            ),
            const _StatCard(
              title: 'Đăng nhập',
              value: 'Ready',
              icon: Icons.lock_open_rounded,
              color: Color(0xFFEF6C00),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiến độ theo tài liệu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1B2430),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Project đã được dựng lại theo cấu trúc thư mục trong tài liệu và hoàn thành đến mục 5: đăng nhập, layout quản trị, quản lý danh mục sản phẩm và quản lý thuộc tính sản phẩm.',
                  style: TextStyle(
                    height: 1.6,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B2430),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
