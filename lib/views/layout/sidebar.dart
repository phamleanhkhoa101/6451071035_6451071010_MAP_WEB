import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.onNavigate,
    this.currentRoute = '/dashboard',
  });

  final ValueChanged<String> onNavigate;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFF131A2A),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bolt_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Flexible(
                  child: Text(
                    'SHOE ADMIN',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Divider(color: Colors.white12),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              children: [
                _sectionTitle('MAIN MENU'),
                _item(Icons.dashboard_outlined, 'Bảng điều khiển', '/dashboard'),
                _item(Icons.category_outlined, 'Danh mục sản phẩm', '/categories'),
                _item(
                  Icons.tune_rounded,
                  'Danh mục thuộc tính sản phẩm',
                  '/attributes',
                ),
                _item(Icons.branding_watermark_outlined, 'Thương hiệu', '/brands'),
                _item(Icons.card_giftcard_outlined, 'Mã giảm giá', '/coupons'),
                _item(Icons.inventory_2_outlined, 'Sản phẩm', '/products'),
                _sectionTitle('SALES'),
                _item(Icons.shopping_cart_outlined, 'Đơn hàng', '/orders'),
                _item(Icons.people_outline_rounded, 'Khách hàng', '/customers'),
                _item(Icons.star_outline_rounded, 'Đánh giá', '/reviews'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'v1.0.0',
              style: TextStyle(color: Colors.white30, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, String route) {
    final isActive = currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () => onNavigate(route),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0x221976D2) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isActive
                ? Border.all(color: const Color(0xFF1976D2))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive ? Colors.white : Colors.white60,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white60,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
