import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../shared/admin_ui.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1180;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroBanner(isWide: isWide),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: const [
                  _ProductsCard(),
                  _OrdersCard(),
                  _CustomersCard(),
                  _RevenueCard(),
                  _PendingReviewsCard(),
                  _LowStockCard(),
                ],
              ),
              const SizedBox(height: 20),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 7, child: _OrdersOverviewCard()),
                    SizedBox(width: 16),
                    Expanded(flex: 5, child: _StoreHealthCard()),
                  ],
                )
              else
                const Column(
                  children: [
                    _OrdersOverviewCard(),
                    SizedBox(height: 16),
                    _StoreHealthCard(),
                  ],
                ),
              const SizedBox(height: 20),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: _TopBrandsCard()),
                    SizedBox(width: 16),
                    Expanded(child: _LatestOrdersCard()),
                    SizedBox(width: 16),
                    Expanded(child: _RecentReviewsCard()),
                  ],
                )
              else
                const Column(
                  children: [
                    _TopBrandsCard(),
                    SizedBox(height: 16),
                    _LatestOrdersCard(),
                    SizedBox(height: 16),
                    _RecentReviewsCard(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F4C81), Color(0xFF138A9B)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F4C81),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: isWide
          ? const Row(
              children: [
                Expanded(child: _HeroText()),
                SizedBox(width: 24),
                _HeroHighlights(),
              ],
            )
          : const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroText(),
                SizedBox(height: 20),
                _HeroHighlights(),
              ],
            ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'PHONE STORE CONTROL CENTER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Theo doi san pham, don hang, khach hang va danh gia tren cung mot man hinh de quan tri cua hang dien thoai nhanh hon.',
          style: TextStyle(
            color: Color(0xFFE6F4FF),
            fontSize: 15,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _BannerChip(
              icon: Icons.sell_rounded,
              label: 'Catalog ready',
            ),
            _BannerChip(
              icon: Icons.local_shipping_outlined,
              label: 'Orders tracked',
            ),
            _BannerChip(
              icon: Icons.verified_user_outlined,
              label: 'Store seeded',
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroHighlights extends StatelessWidget {
  const _HeroHighlights();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MiniStat(
              label: 'Focus today',
              value: 'Xu ly don dang giao va review cho duyet',
            ),
            SizedBox(height: 14),
            _MiniStat(
              label: 'Traffic source',
              value: 'iPhone + Samsung dang chiem phan lon luot xem',
            ),
            SizedBox(height: 14),
            _MiniStat(
              label: 'Quick note',
              value: 'Kiem tra ton kho nhom flagship va cap nhat trang thai don hang.',
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerChip extends StatelessWidget {
  const _BannerChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFD8EEFF),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ProductsCard extends StatelessWidget {
  const _ProductsCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DashboardPage._db.collection('products').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];
        final publishedCount = docs
            .where((doc) => _readProductStatus(doc.data()) == 'published')
            .length;

        return _DashboardCard(
          width: 220,
          title: 'Products',
          value: '${docs.length}',
          subtitle: '$publishedCount dang hien thi',
          icon: Icons.smartphone_rounded,
          color: const Color(0xFF1565C0),
        );
      },
    );
  }
}

class _OrdersCard extends StatelessWidget {
  const _OrdersCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DashboardPage._db.collection('orders').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];
        final shippingCount = docs
            .where((doc) => _readOrderStatus(doc.data()) == 'shipping')
            .length;

        return _DashboardCard(
          width: 220,
          title: 'Orders',
          value: '${docs.length}',
          subtitle: '$shippingCount don dang giao',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFF00897B),
        );
      },
    );
  }
}

class _CustomersCard extends StatelessWidget {
  const _CustomersCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DashboardPage._db.collection('customers').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];
        final vipCount = docs
            .where((doc) => _stringValue(doc.data()['tier']).toLowerCase() == 'vip')
            .length;

        return _DashboardCard(
          width: 220,
          title: 'Customers',
          value: '${docs.length}',
          subtitle: '$vipCount khach VIP',
          icon: Icons.people_alt_outlined,
          color: const Color(0xFF6D4C41),
        );
      },
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DashboardPage._db.collection('orders').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];
        final totalRevenue = docs
            .where((doc) => _readOrderStatus(doc.data()) == 'delivered')
            .fold<double>(
              0,
              (sum, doc) => sum + _doubleValue(doc.data()['totalAmount']),
            );

        return _DashboardCard(
          width: 260,
          title: 'Delivered revenue',
          value: formatCurrency(totalRevenue),
          subtitle: 'Doanh thu da giao thanh cong',
          icon: Icons.payments_outlined,
          color: const Color(0xFFEF6C00),
        );
      },
    );
  }
}

class _PendingReviewsCard extends StatelessWidget {
  const _PendingReviewsCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DashboardPage._db.collection('product_reviews').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];
        final pendingCount = docs
            .where(
              (doc) =>
                  _stringValue(doc.data()['status']).toLowerCase() == 'pending',
            )
            .length;

        return _DashboardCard(
          width: 220,
          title: 'Pending reviews',
          value: '$pendingCount',
          subtitle: 'Danh gia can duyet',
          icon: Icons.rate_review_outlined,
          color: const Color(0xFF8E24AA),
        );
      },
    );
  }
}

class _LowStockCard extends StatelessWidget {
  const _LowStockCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DashboardPage._db.collection('products').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];
        final lowStockCount = docs
            .where((doc) => _intValue(doc.data()['stock']) <= 20)
            .length;

        return _DashboardCard(
          width: 220,
          title: 'Low stock',
          value: '$lowStockCount',
          subtitle: 'San pham can bo sung',
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFD84315),
        );
      },
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.width,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final double width;
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1B2430),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersOverviewCard extends StatelessWidget {
  const _OrdersOverviewCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DashboardPage._db.collection('orders').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];
        final total = docs.length;
        final pending = docs
            .where((doc) => _readOrderStatus(doc.data()) == 'pending')
            .length;
        final shipping = docs
            .where((doc) => _readOrderStatus(doc.data()) == 'shipping')
            .length;
        final delivered = docs
            .where((doc) => _readOrderStatus(doc.data()) == 'delivered')
            .length;

        return AdminSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order pipeline',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B2430),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Theo doi nhanh cac nhom trang thai don hang trong ngay.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              _StatusMeter(
                label: 'Pending',
                count: pending,
                total: total,
                color: const Color(0xFFEF6C00),
              ),
              const SizedBox(height: 14),
              _StatusMeter(
                label: 'Shipping',
                count: shipping,
                total: total,
                color: const Color(0xFF1565C0),
              ),
              const SizedBox(height: 14),
              _StatusMeter(
                label: 'Delivered',
                count: delivered,
                total: total,
                color: const Color(0xFF2E7D32),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusMeter extends StatelessWidget {
  const _StatusMeter({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : count / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B2430),
              ),
            ),
            const Spacer(),
            Text(
              '$count / $total',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 12,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _StoreHealthCard extends StatelessWidget {
  const _StoreHealthCard();

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Store health',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1B2430),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nhung viec can chu y de giu dashboard van hanh on dinh.',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),
          const _ChecklistItem(
            color: Color(0xFF1565C0),
            icon: Icons.inventory_2_outlined,
            title: 'Dong bo catalog',
            description: 'Kiem tra lai gia, ton kho va anh dai dien nhom flagship.',
          ),
          const SizedBox(height: 12),
          const _ChecklistItem(
            color: Color(0xFFEF6C00),
            icon: Icons.rate_review_outlined,
            title: 'Duyet review moi',
            description: 'Xu ly nhung danh gia pending truoc khi chay quang cao.',
          ),
          const SizedBox(height: 12),
          const _ChecklistItem(
            color: Color(0xFF2E7D32),
            icon: Icons.local_shipping_outlined,
            title: 'Cap nhat giao hang',
            description: 'Chuyen cac don da giao thanh cong sang delivered.',
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1B2430),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    height: 1.5,
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

class _TopBrandsCard extends StatelessWidget {
  const _TopBrandsCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DashboardPage._db.collection('products').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];
        final brandCounter = <String, int>{};

        for (final doc in docs) {
          final brand = _stringValue(doc.data()['brand']);
          if (brand.isEmpty) {
            continue;
          }
          brandCounter.update(brand, (value) => value + 1, ifAbsent: () => 1);
        }

        final topBrands = brandCounter.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return AdminSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top brands',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B2430),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Thuong hieu dang co nhieu san pham nhat trong he thong.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              if (topBrands.isEmpty)
                const Text('Chua co du lieu thuong hieu.')
              else
                ...topBrands.take(5).toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == 4 ? 0 : 12),
                    child: _RankRow(
                      rank: index + 1,
                      title: item.key,
                      trailing: '${item.value} products',
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _LatestOrdersCard extends StatelessWidget {
  const _LatestOrdersCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DashboardPage._db
          .collection('orders')
          .orderBy('updatedAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];

        return AdminSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Latest orders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B2430),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Don hang moi cap nhat gan day.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              if (docs.isEmpty)
                const Text('Chua co du lieu don hang.')
              else
                ...docs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value.data();
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == docs.length - 1 ? 0 : 12),
                    child: _TwoLineRow(
                      title: _stringValue(data['orderCode']),
                      subtitle: _stringValue(data['customerName']),
                      trailing: formatCurrency(_doubleValue(data['totalAmount'])),
                      badge: _readOrderStatus(data),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _RecentReviewsCard extends StatelessWidget {
  const _RecentReviewsCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DashboardPage._db
          .collection('product_reviews')
          .orderBy('updatedAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];

        return AdminSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B2430),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Danh gia moi can theo doi va phan hoi.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              if (docs.isEmpty)
                const Text('Chua co du lieu review.')
              else
                ...docs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value.data();
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == docs.length - 1 ? 0 : 12),
                    child: _TwoLineRow(
                      title: _stringValue(data['productName']),
                      subtitle: _stringValue(data['customerName']),
                      trailing: '${_intValue(data['rating'])}/5',
                      badge: _stringValue(data['status']),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.rank,
    required this.title,
    required this.trailing,
  });

  final int rank;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF1565C0),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B2430),
              ),
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TwoLineRow extends StatelessWidget {
  const _TwoLineRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.badge,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1B2430),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                trailing,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B2430),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _TinyBadge(label: badge),
            ],
          ),
        ],
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final normalized = label.toLowerCase();
    final color = normalized == 'delivered' || normalized == 'approved'
        ? const Color(0xFF2E7D32)
        : normalized == 'shipping'
        ? const Color(0xFF1565C0)
        : normalized == 'pending'
        ? const Color(0xFFEF6C00)
        : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

String _readProductStatus(Map<String, dynamic> data) {
  final status = _stringValue(data['status']);
  if (status.isNotEmpty) {
    return status.toLowerCase();
  }
  if (data['isDeleted'] == true) {
    return 'archived';
  }
  if (data['isDraft'] == true) {
    return 'draft';
  }
  if (data['isActive'] == true) {
    return 'published';
  }
  return 'draft';
}

String _readOrderStatus(Map<String, dynamic> data) {
  final raw = _stringValue(data['status']).toLowerCase();
  if (raw.contains('deliver')) {
    return 'delivered';
  }
  if (raw.contains('ship')) {
    return 'shipping';
  }
  if (raw.contains('cancel')) {
    return 'cancelled';
  }
  if (raw.contains('pend')) {
    return 'pending';
  }
  return raw.isEmpty ? 'pending' : raw;
}

String _stringValue(dynamic value) {
  if (value == null) {
    return '';
  }
  if (value is String) {
    return value;
  }
  if (value is num || value is bool) {
    return value.toString();
  }
  if (value is Map) {
    final mapped = Map<String, dynamic>.from(value);
    for (final key in const [
      'name',
      'label',
      'title',
      'value',
      'fullName',
      'phone',
      'address',
    ]) {
      final candidate = _stringValue(mapped[key]);
      if (candidate.isNotEmpty) {
        return candidate;
      }
    }
    return mapped.values
        .map(_stringValue)
        .where((item) => item.isNotEmpty)
        .join(', ');
  }
  if (value is List) {
    return value.map(_stringValue).where((item) => item.isNotEmpty).join(', ');
  }
  return value.toString();
}

double _doubleValue(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _intValue(dynamic value) {
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
