import 'package:cloud_firestore/cloud_firestore.dart';

class SeedDataService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const int currentSeedVersion = 4;

  static const List<String> _categoryNames = [
    'Điện thoại',
    'Phụ kiện',
    'Tablet',
  ];

  static const List<String> _brandNames = [
    'Apple',
    'Samsung',
    'Xiaomi',
    'OPPO',
    'Google',
    'OnePlus',
  ];

  static const List<String> _productTitles = [
    'iPhone 15 Pro Max',
    'Samsung Galaxy S24 Ultra',
    'Xiaomi 14 Ultra',
    'OPPO Find X7 Ultra',
    'iPhone 15',
    'Google Pixel 8 Pro',
    'OnePlus 12',
    'Samsung Galaxy A55',
    'iPhone 14',
  ];

  static const List<String> _orderCodes = [
    'ORD-240501',
    'ORD-240502',
    'ORD-240503',
    'ORD-240504',
    'ORD-240505',
  ];

  static const List<String> _customerEmails = [
    'anh.nguyen@example.com',
    'minh.tran@example.com',
    'linh.le@example.com',
    'huy.pham@example.com',
    'thu.vo@example.com',
  ];

  static const List<String> _reviewKeys = [
    'iPhone 15 Pro Max|Anh Nguyen',
    'Samsung Galaxy S24 Ultra|Minh Tran',
    'Xiaomi 14 Ultra|Linh Le',
    'iPhone 15|Huy Pham',
    'Google Pixel 8 Pro|Thu Vo',
  ];

  static Future<bool> seedPhoneData() async {
    try {
      await _addCategories();
      await _addBrands();
      await _addPhoneProducts();
      await _addCustomers();
      await _addOrders();
      await _addReviews();
      return hasRequiredSeedData();
    } catch (_) {
      return false;
    }
  }

  static Future<bool> hasRequiredSeedData() async {
    try {
      final categorySnapshot = await _db
          .collection('categories')
          .where('name', whereIn: _categoryNames)
          .get();
      final brandSnapshot = await _db
          .collection('brands')
          .where('name', whereIn: _brandNames)
          .get();
      final productSnapshot = await _db
          .collection('products')
          .where('title', whereIn: _productTitles)
          .get();
      final orderSnapshot = await _db
          .collection('orders')
          .where('orderCode', whereIn: _orderCodes)
          .get();
      final customerSnapshot = await _db
          .collection('customers')
          .where('email', whereIn: _customerEmails)
          .get();
      final reviewSnapshot = await _db.collection('product_reviews').get();

      final reviewCount = reviewSnapshot.docs
          .map((doc) {
            final data = doc.data();
            return '${data['productName']}|${data['customerName']}';
          })
          .where(_reviewKeys.contains)
          .toSet()
          .length;

      return categorySnapshot.docs.length >= _categoryNames.length &&
          brandSnapshot.docs.length >= _brandNames.length &&
          productSnapshot.docs.length >= _productTitles.length &&
          orderSnapshot.docs.length >= _orderCodes.length &&
          customerSnapshot.docs.length >= _customerEmails.length &&
          reviewCount >= _reviewKeys.length;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _addCategories() async {
    final now = Timestamp.now();
    final categories = [
      {
        'name': 'Điện thoại',
        'imageURL': 'https://placehold.co/96x96/png?text=Phone',
        'isActive': true,
        'isFeatured': true,
        'priority': 1,
        'numberOfProducts': 9,
        'viewCount': 1600,
        'createdBy': 'admin',
        'updatedBy': 'admin',
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'Phụ kiện',
        'imageURL': 'https://placehold.co/96x96/png?text=Gear',
        'isActive': true,
        'isFeatured': true,
        'priority': 2,
        'numberOfProducts': 4,
        'viewCount': 920,
        'createdBy': 'admin',
        'updatedBy': 'admin',
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'Tablet',
        'imageURL': 'https://placehold.co/96x96/png?text=Tablet',
        'isActive': true,
        'isFeatured': false,
        'priority': 3,
        'numberOfProducts': 3,
        'viewCount': 610,
        'createdBy': 'admin',
        'updatedBy': 'admin',
        'createdAt': now,
        'updatedAt': now,
      },
    ];

    for (final category in categories) {
      await _upsertByField(
        collection: 'categories',
        field: 'name',
        value: category['name'] as String,
        data: category,
      );
    }
  }

  static Future<void> _addBrands() async {
    final now = Timestamp.now();
    final brands = [
      {
        'name': 'Apple',
        'logoUrl': 'assets/images/brands/apple.png',
        'description': 'Flagship iPhone and ecosystem devices.',
        'isFeatured': true,
        'isActive': true,
        'priority': 1,
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'Samsung',
        'logoUrl': 'assets/images/brands/samsung.png',
        'description':
            'Premium Android phones and best-selling midrange models.',
        'isFeatured': true,
        'isActive': true,
        'priority': 2,
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'Xiaomi',
        'logoUrl': 'assets/images/brands/xiaomi.png',
        'description': 'Value-packed phones with strong performance.',
        'isFeatured': true,
        'isActive': true,
        'priority': 3,
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'OPPO',
        'logoUrl': 'assets/images/brands/oppo.png',
        'description': 'Design-led smartphones with fast charging.',
        'isFeatured': true,
        'isActive': true,
        'priority': 4,
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'Google',
        'logoUrl': 'assets/images/brands/google.png',
        'description': 'Pixel phones focused on AI and camera quality.',
        'isFeatured': true,
        'isActive': true,
        'priority': 5,
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'OnePlus',
        'logoUrl': 'assets/images/brands/one-plus.png',
        'description': 'Performance-focused Android phones.',
        'isFeatured': true,
        'isActive': true,
        'priority': 6,
        'createdAt': now,
        'updatedAt': now,
      },
    ];

    for (final brand in brands) {
      await _upsertByField(
        collection: 'brands',
        field: 'name',
        value: brand['name'] as String,
        data: brand,
      );
    }
  }

  static Future<void> _addPhoneProducts() async {
    final phoneCategoryId = await _getCategoryId('Điện thoại');
    final products = [
      await _buildProduct(
        title: 'iPhone 15 Pro Max',
        sku: 'IP15PM-001',
        brand: 'Apple',
        category: 'Điện thoại',
        price: 33900000,
        originalPrice: 34900000,
        stock: 72,
        summary: 'Apple flagship with premium cameras and large battery life.',
        imageUrl: 'assets/images/smartphones/thumb_iphone15.png',
        rating: 4.9,
        categoryId: phoneCategoryId,
      ),
      await _buildProduct(
        title: 'Samsung Galaxy S24 Ultra',
        sku: 'SGS24U-001',
        brand: 'Samsung',
        category: 'Điện thoại',
        price: 28900000,
        originalPrice: 30900000,
        stock: 58,
        summary: 'Top Samsung model with S Pen and 200MP camera.',
        imageUrl: 'assets/images/smartphones/thumb_samsung_s24_ultra.png',
        rating: 4.8,
        categoryId: phoneCategoryId,
      ),
      await _buildProduct(
        title: 'Xiaomi 14 Ultra',
        sku: 'XM14U-001',
        brand: 'Xiaomi',
        category: 'Điện thoại',
        price: 21900000,
        originalPrice: 22900000,
        stock: 81,
        summary: 'Leica camera system and high-end flagship performance.',
        imageUrl: 'assets/images/smartphones/thumb_xiaomi14_ultra.png',
        rating: 4.7,
        categoryId: phoneCategoryId,
      ),
      await _buildProduct(
        title: 'OPPO Find X7 Ultra',
        sku: 'OPFX7U-001',
        brand: 'OPPO',
        category: 'Điện thoại',
        price: 31900000,
        originalPrice: 32900000,
        stock: 36,
        summary: 'Luxury Android flagship with standout portrait cameras.',
        imageUrl: 'assets/images/smartphones/thumb_oppo_find_x7_ultra.png',
        rating: 4.6,
        categoryId: phoneCategoryId,
      ),
      await _buildProduct(
        title: 'iPhone 15',
        sku: 'IP15-001',
        brand: 'Apple',
        category: 'Điện thoại',
        price: 17900000,
        originalPrice: 18900000,
        stock: 140,
        summary: 'Balanced iPhone model with excellent day-to-day experience.',
        imageUrl: 'assets/images/smartphones/thumb_iphone15.png',
        rating: 4.7,
        categoryId: phoneCategoryId,
      ),
      await _buildProduct(
        title: 'Google Pixel 8 Pro',
        sku: 'GP8P-001',
        brand: 'Google',
        category: 'Điện thoại',
        price: 12900000,
        originalPrice: 13900000,
        stock: 64,
        summary: 'Clean Android, AI features, and accurate mobile photography.',
        imageUrl: 'assets/images/smartphones/thumb_pixel8_pro.png',
        rating: 4.6,
        categoryId: phoneCategoryId,
      ),
      await _buildProduct(
        title: 'OnePlus 12',
        sku: 'OP12-001',
        brand: 'OnePlus',
        category: 'Điện thoại',
        price: 15900000,
        originalPrice: 16900000,
        stock: 76,
        summary: 'Fast, smooth, and performance-focused Android flagship.',
        imageUrl: 'assets/images/smartphones/thumb_oneplus12.png',
        rating: 4.6,
        categoryId: phoneCategoryId,
      ),
      await _buildProduct(
        title: 'Samsung Galaxy A55',
        sku: 'SGA55-001',
        brand: 'Samsung',
        category: 'Điện thoại',
        price: 7900000,
        originalPrice: 8500000,
        stock: 180,
        summary: 'Popular midrange phone with solid battery and display.',
        imageUrl: 'assets/images/smartphones/thumb_samsung_a55.png',
        rating: 4.4,
        categoryId: phoneCategoryId,
      ),
      await _buildProduct(
        title: 'iPhone 14',
        sku: 'IP14-001',
        brand: 'Apple',
        category: 'Điện thoại',
        price: 13900000,
        originalPrice: 14900000,
        stock: 96,
        summary: 'A still-strong iPhone option with good camera and stability.',
        imageUrl: 'assets/images/smartphones/thumb_iphone14.png',
        rating: 4.5,
        categoryId: phoneCategoryId,
      ),
    ];

    for (final product in products) {
      await _upsertByField(
        collection: 'products',
        field: 'title',
        value: product['title'] as String,
        data: product,
      );
    }
  }

  static Future<void> _addCustomers() async {
    final customers = [
      _customer(
        fullName: 'Anh Nguyen',
        email: 'anh.nguyen@example.com',
        phone: '0901000001',
        city: 'Ho Chi Minh City',
        tier: 'vip',
        status: 'active',
        totalOrders: 6,
        totalSpent: 127900000,
        daysAgo: 60,
      ),
      _customer(
        fullName: 'Minh Tran',
        email: 'minh.tran@example.com',
        phone: '0901000002',
        city: 'Da Nang',
        tier: 'standard',
        status: 'active',
        totalOrders: 3,
        totalSpent: 46300000,
        daysAgo: 42,
      ),
      _customer(
        fullName: 'Linh Le',
        email: 'linh.le@example.com',
        phone: '0901000003',
        city: 'Can Tho',
        tier: 'vip',
        status: 'active',
        totalOrders: 4,
        totalSpent: 71800000,
        daysAgo: 31,
      ),
      _customer(
        fullName: 'Huy Pham',
        email: 'huy.pham@example.com',
        phone: '0901000004',
        city: 'Ha Noi',
        tier: 'standard',
        status: 'active',
        totalOrders: 2,
        totalSpent: 25800000,
        daysAgo: 21,
      ),
      _customer(
        fullName: 'Thu Vo',
        email: 'thu.vo@example.com',
        phone: '0901000005',
        city: 'Hue',
        tier: 'wholesale',
        status: 'active',
        totalOrders: 5,
        totalSpent: 94200000,
        daysAgo: 12,
      ),
    ];

    for (final customer in customers) {
      await _upsertByField(
        collection: 'customers',
        field: 'email',
        value: customer['email'] as String,
        data: customer,
      );
    }
  }

  static Future<void> _addOrders() async {
    final orders = [
      _order(
        orderCode: 'ORD-240501',
        customerName: 'Anh Nguyen',
        customerPhone: '0901000001',
        shippingAddress: 'District 1, Ho Chi Minh City',
        paymentMethod: 'Card',
        status: 'delivered',
        itemsCount: 2,
        totalAmount: 37500000,
        note: 'Priority delivery for flagship customer.',
        daysAgo: 9,
      ),
      _order(
        orderCode: 'ORD-240502',
        customerName: 'Minh Tran',
        customerPhone: '0901000002',
        shippingAddress: 'Hai Chau, Da Nang',
        paymentMethod: 'COD',
        status: 'pending',
        itemsCount: 1,
        totalAmount: 7900000,
        note: 'Waiting for customer confirmation.',
        daysAgo: 7,
      ),
      _order(
        orderCode: 'ORD-240503',
        customerName: 'Linh Le',
        customerPhone: '0901000003',
        shippingAddress: 'Ninh Kieu, Can Tho',
        paymentMethod: 'Bank transfer',
        status: 'shipping',
        itemsCount: 1,
        totalAmount: 21900000,
        note: 'Shipped with insurance.',
        daysAgo: 5,
      ),
      _order(
        orderCode: 'ORD-240504',
        customerName: 'Huy Pham',
        customerPhone: '0901000004',
        shippingAddress: 'Cau Giay, Ha Noi',
        paymentMethod: 'COD',
        status: 'delivered',
        itemsCount: 1,
        totalAmount: 12900000,
        note: 'Customer requested evening delivery.',
        daysAgo: 4,
      ),
      _order(
        orderCode: 'ORD-240505',
        customerName: 'Thu Vo',
        customerPhone: '0901000005',
        shippingAddress: 'Phu Vang, Hue',
        paymentMethod: 'Bank transfer',
        status: 'shipping',
        itemsCount: 3,
        totalAmount: 47700000,
        note: 'Bulk order with extra charger gifts.',
        daysAgo: 2,
      ),
    ];

    for (final order in orders) {
      await _upsertByField(
        collection: 'orders',
        field: 'orderCode',
        value: order['orderCode'] as String,
        data: order,
      );
    }
  }

  static Future<void> _addReviews() async {
    final reviews = [
      _review(
        productName: 'iPhone 15 Pro Max',
        customerName: 'Anh Nguyen',
        comment: 'Premium finish, smooth camera zoom, and great battery life.',
        rating: 5,
        status: 'approved',
        daysAgo: 8,
      ),
      _review(
        productName: 'Samsung Galaxy S24 Ultra',
        customerName: 'Minh Tran',
        comment: 'Excellent display and S Pen experience for work.',
        rating: 5,
        status: 'approved',
        daysAgo: 6,
      ),
      _review(
        productName: 'Xiaomi 14 Ultra',
        customerName: 'Linh Le',
        comment: 'Camera quality is strong, but stock sold out quickly.',
        rating: 4,
        status: 'pending',
        daysAgo: 5,
      ),
      _review(
        productName: 'iPhone 15',
        customerName: 'Huy Pham',
        comment: 'Good all-round phone and easy to recommend.',
        rating: 4,
        status: 'approved',
        daysAgo: 3,
      ),
      _review(
        productName: 'Google Pixel 8 Pro',
        customerName: 'Thu Vo',
        comment: 'Photo processing is nice, but delivery should be faster.',
        rating: 4,
        status: 'pending',
        daysAgo: 2,
      ),
    ];

    for (final review in reviews) {
      await _upsertByPair(
        collection: 'product_reviews',
        firstField: 'productName',
        firstValue: review['productName'] as String,
        secondField: 'customerName',
        secondValue: review['customerName'] as String,
        data: review,
      );
    }
  }

  static Future<Map<String, dynamic>> _buildProduct({
    required String title,
    required String sku,
    required String brand,
    required String category,
    required double price,
    required double originalPrice,
    required int stock,
    required String summary,
    required String imageUrl,
    required double rating,
    required String? categoryId,
  }) async {
    final brandId = await _getBrandId(brand);
    final now = Timestamp.now();

    return {
      'title': title,
      'sku': sku,
      'brand': brand,
      'brandName': brand,
      'brandId': brandId,
      'category': category,
      'categoryName': category,
      'categoryIds': categoryId == null ? <String>[] : [categoryId],
      'price': price,
      'originalPrice': originalPrice,
      'salePrice': originalPrice,
      'stock': stock,
      'status': 'published',
      'summary': summary,
      'description': summary,
      'imageUrl': imageUrl,
      'thumbnail': imageUrl,
      'isFeatured': true,
      'isActive': true,
      'isDraft': false,
      'isDeleted': false,
      'productType': 'simple',
      'rating': rating,
      'ratingCount': (rating * 100).round(),
      'reviewsCount': (rating * 20).round(),
      'soldQuantity': stock ~/ 3,
      'createdAt': now,
      'updatedAt': now,
    };
  }

  static Map<String, dynamic> _customer({
    required String fullName,
    required String email,
    required String phone,
    required String city,
    required String tier,
    required String status,
    required int totalOrders,
    required double totalSpent,
    required int daysAgo,
  }) {
    final timestamp = _timestampFromDaysAgo(daysAgo);
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'city': city,
      'tier': tier,
      'status': status,
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'createdAt': timestamp,
      'updatedAt': timestamp,
    };
  }

  static Map<String, dynamic> _order({
    required String orderCode,
    required String customerName,
    required String customerPhone,
    required String shippingAddress,
    required String paymentMethod,
    required String status,
    required int itemsCount,
    required double totalAmount,
    required String note,
    required int daysAgo,
  }) {
    final timestamp = _timestampFromDaysAgo(daysAgo);
    return {
      'orderCode': orderCode,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'status': status,
      'itemsCount': itemsCount,
      'totalAmount': totalAmount,
      'note': note,
      'createdAt': timestamp,
      'updatedAt': timestamp,
    };
  }

  static Map<String, dynamic> _review({
    required String productName,
    required String customerName,
    required String comment,
    required int rating,
    required String status,
    required int daysAgo,
  }) {
    final timestamp = _timestampFromDaysAgo(daysAgo);
    return {
      'productName': productName,
      'customerName': customerName,
      'comment': comment,
      'rating': rating,
      'status': status,
      'createdAt': timestamp,
      'updatedAt': timestamp,
    };
  }

  static Timestamp _timestampFromDaysAgo(int daysAgo) {
    return Timestamp.fromDate(DateTime.now().subtract(Duration(days: daysAgo)));
  }

  static Future<void> _upsertByField({
    required String collection,
    required String field,
    required String value,
    required Map<String, dynamic> data,
  }) async {
    final existing = await _db
        .collection(collection)
        .where(field, isEqualTo: value)
        .limit(1)
        .get();

    if (existing.docs.isEmpty) {
      await _db.collection(collection).add(data);
      return;
    }

    await existing.docs.first.reference.update(data);
  }

  static Future<void> _upsertByPair({
    required String collection,
    required String firstField,
    required String firstValue,
    required String secondField,
    required String secondValue,
    required Map<String, dynamic> data,
  }) async {
    final existing = await _db
        .collection(collection)
        .where(firstField, isEqualTo: firstValue)
        .where(secondField, isEqualTo: secondValue)
        .limit(1)
        .get();

    if (existing.docs.isEmpty) {
      await _db.collection(collection).add(data);
      return;
    }

    await existing.docs.first.reference.update(data);
  }

  static Future<String?> _getBrandId(String brandName) async {
    final snapshot = await _db
        .collection('brands')
        .where('name', isEqualTo: brandName)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;
  }

  static Future<String?> _getCategoryId(String categoryName) async {
    final snapshot = await _db
        .collection('categories')
        .where('name', isEqualTo: categoryName)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;
  }
}
