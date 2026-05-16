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

  static const List<String> _orderIds = [
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
          .where('id', whereIn: _orderIds)
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
          orderSnapshot.docs.length >= _orderIds.length &&
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
        'imageURL': 'assets/images/icons/phone.png',
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
        'imageURL': 'assets/images/icons/headphones.png',
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
        'imageURL': 'assets/images/icons/tablet.png',
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
        imageUrl: 'assets/images/smartphones/thumb_iphone15.jpg',
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
        imageUrl: 'assets/images/smartphones/thumb_samsung_s24_ultra.jpg',
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
        imageUrl: 'assets/images/smartphones/thumb_xiaomi14_ultra.jpg',
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
        imageUrl: 'assets/images/smartphones/thumb_oppo_find_x7_ultra.jpg',
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
        imageUrl: 'assets/images/smartphones/thumb_iphone15.jpg',
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
        imageUrl: 'assets/images/smartphones/thumb_pixel8_pro.jpg',
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
        imageUrl: 'assets/images/smartphones/thumb_oneplus12.jpg',
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
        imageUrl: 'assets/images/smartphones/thumb_samsung_a55.jpg',
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
        imageUrl: 'assets/images/smartphones/thumb_iphone14.jpg',
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
        firstName: 'Anh',
        lastName: 'Nguyen',
        email: 'anh.nguyen@example.com',
        phone: '0901000001',
        username: 'anh.nguyen',
        gender: 'Male',
        daysAgo: 60,
      ),
      _customer(
        firstName: 'Minh',
        lastName: 'Tran',
        email: 'minh.tran@example.com',
        phone: '0901000002',
        username: 'minh.tran',
        gender: 'Male',
        daysAgo: 42,
      ),
      _customer(
        firstName: 'Linh',
        lastName: 'Le',
        email: 'linh.le@example.com',
        phone: '0901000003',
        username: 'linh.le',
        gender: 'Female',
        daysAgo: 31,
      ),
      _customer(
        firstName: 'Huy',
        lastName: 'Pham',
        email: 'huy.pham@example.com',
        phone: '0901000004',
        username: 'huy.pham',
        gender: 'Male',
        daysAgo: 21,
      ),
      _customer(
        firstName: 'Thu',
        lastName: 'Vo',
        email: 'thu.vo@example.com',
        phone: '0901000005',
        username: 'thu.vo',
        gender: 'Female',
        daysAgo: 12,
      ),
    ];

    for (final customer in customers) {
      await _upsertByField(
        collection: 'users',
        field: 'email',
        value: customer['email'] as String,
        data: customer,
      );
    }
  }

  static Future<void> _addOrders() async {
    final orders = [
      _order(
        id: 'ORD-240501',
        userId: 'seed-user-001',
        customerName: 'Anh Nguyen',
        shippingAddress: {'fullName': 'Anh Nguyen', 'street': 'District 1', 'city': 'Ho Chi Minh City', 'phone': '0901000001'},
        paymentMethod: 'card',
        paymentMethodType: 'visa',
        orderStatus: 'delivered',
        paymentStatus: 'paid',
        itemCount: 2,
        subTotal: 35000000,
        taxRate: 0.08,
        taxAmount: 2800000,
        shippingAmount: 0,
        totalDiscountAmount: 500000,
        couponDiscountAmount: 0,
        totalAmount: 37300000,
        daysAgo: 9,
      ),
      _order(
        id: 'ORD-240502',
        userId: 'seed-user-002',
        customerName: 'Minh Tran',
        shippingAddress: {'fullName': 'Minh Tran', 'street': 'Hai Chau', 'city': 'Da Nang', 'phone': '0901000002'},
        paymentMethod: 'cod',
        paymentMethodType: 'cash',
        orderStatus: 'pending',
        paymentStatus: 'pending',
        itemCount: 1,
        subTotal: 7900000,
        taxRate: 0.08,
        taxAmount: 632000,
        shippingAmount: 30000,
        totalDiscountAmount: 0,
        couponDiscountAmount: 0,
        totalAmount: 8562000,
        daysAgo: 7,
      ),
      _order(
        id: 'ORD-240503',
        userId: 'seed-user-003',
        customerName: 'Linh Le',
        shippingAddress: {'fullName': 'Linh Le', 'street': 'Ninh Kieu', 'city': 'Can Tho', 'phone': '0901000003'},
        paymentMethod: 'bank_transfer',
        paymentMethodType: 'banking',
        orderStatus: 'shipped',
        paymentStatus: 'paid',
        itemCount: 1,
        subTotal: 21900000,
        taxRate: 0.08,
        taxAmount: 1752000,
        shippingAmount: 50000,
        totalDiscountAmount: 0,
        couponDiscountAmount: 0,
        totalAmount: 23702000,
        daysAgo: 5,
      ),
      _order(
        id: 'ORD-240504',
        userId: 'seed-user-004',
        customerName: 'Huy Pham',
        shippingAddress: {'fullName': 'Huy Pham', 'street': 'Cau Giay', 'city': 'Ha Noi', 'phone': '0901000004'},
        paymentMethod: 'cod',
        paymentMethodType: 'cash',
        orderStatus: 'delivered',
        paymentStatus: 'paid',
        itemCount: 1,
        subTotal: 12900000,
        taxRate: 0.08,
        taxAmount: 1032000,
        shippingAmount: 30000,
        totalDiscountAmount: 0,
        couponDiscountAmount: 0,
        totalAmount: 13962000,
        daysAgo: 4,
      ),
      _order(
        id: 'ORD-240505',
        userId: 'seed-user-005',
        customerName: 'Thu Vo',
        shippingAddress: {'fullName': 'Thu Vo', 'street': 'Phu Vang', 'city': 'Hue', 'phone': '0901000005'},
        paymentMethod: 'bank_transfer',
        paymentMethodType: 'banking',
        orderStatus: 'shipped',
        paymentStatus: 'paid',
        itemCount: 3,
        subTotal: 47700000,
        taxRate: 0.08,
        taxAmount: 3816000,
        shippingAmount: 0,
        totalDiscountAmount: 1000000,
        couponDiscountAmount: 500000,
        totalAmount: 50016000,
        daysAgo: 2,
      ),
    ];

    for (final order in orders) {
      await _upsertByField(
        collection: 'orders',
        field: 'id',
        value: order['id'] as String,
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
      'lowerTitle': title.toLowerCase(),
      'description': summary,
      'sku': sku,
      'price': originalPrice,
      'salePrice': price,
      'thumbnail': imageUrl,
      'images': [imageUrl],
      'productType': 'simple',
      'stock': stock,
      'isOutOfStock': stock <= 0,
      'soldQuantity': stock ~/ 3,
      'brandId': brandId,
      'categoryIds': categoryId == null ? <String>[] : [categoryId],
      'tags': <String>[],
      'attributes': <Map<String, dynamic>>[],
      'variations': <Map<String, dynamic>>[],
      'isRecommended': true,
      'isFeatured': true,
      'isActive': true,
      'isDraft': false,
      'isDeleted': false,
      'onSale': false,
      'saleStartDate': null,
      'saleEndDate': null,
      'views': 0,
      'rating': rating,
      'ratingCount': (rating * 100).round(),
      'reviewsCount': (rating * 20).round(),
      'fiveStarCount': 0,
      'fourStarCount': 0,
      'threeStarCount': 0,
      'twoStarCount': 0,
      'oneStarCount': 0,
      'likes': 0,
      'createdAt': now,
      'updatedAt': now,
    };
  }

  static Map<String, dynamic> _customer({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String username,
    required String gender,
    required int daysAgo,
  }) {
    final timestamp = _timestampFromDaysAgo(daysAgo);
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'username': username,
      'gender': gender,
      'createdAt': timestamp.toDate().toIso8601String(),
    };
  }

  static Map<String, dynamic> _order({
    required String id,
    required String userId,
    required String customerName,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
    required String paymentMethodType,
    required String orderStatus,
    required String paymentStatus,
    required int itemCount,
    required double subTotal,
    required double taxRate,
    required double taxAmount,
    required double shippingAmount,
    required double totalDiscountAmount,
    required double couponDiscountAmount,
    required double totalAmount,
    required int daysAgo,
  }) {
    final timestamp = _timestampFromDaysAgo(daysAgo);
    return {
      'id': id,
      'userId': userId,
      'customerName': customerName,
      'products': <Map<String, dynamic>>[],
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'paymentMethodType': paymentMethodType,
      'orderStatus': orderStatus,
      'paymentStatus': paymentStatus,
      'itemCount': itemCount,
      'subTotal': subTotal,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'shippingAmount': shippingAmount,
      'totalDiscountAmount': totalDiscountAmount,
      'couponDiscountAmount': couponDiscountAmount,
      'totalAmount': totalAmount,
      'orderDate': timestamp,
      'createdAt': timestamp,
      'updatedAt': timestamp,
      'shippingDate': null,
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
