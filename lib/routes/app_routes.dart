import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../views/attributes/attribute_page.dart';
import '../views/auth/login_page.dart';
import '../views/brands/brands_page.dart';
import '../views/cagetories/category_page.dart';
import '../views/coupons/coupons_page.dart';
import '../views/customers/customers_page.dart';
import '../views/dashboard/dashboard_page.dart';
import '../views/layout/admin_layout.dart';
import '../views/orders/orders_page.dart';
import '../views/product_review/all_review_screen.dart';
import '../views/products/product_list_page.dart';

class AppRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  AppRouterDelegate(this.authController)
    : navigatorKey = GlobalKey<NavigatorState>() {
    authController.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> navigatorKey;
  final AuthController authController;

  String _currentPath = '/login';

  @override
  String? get currentConfiguration => _currentPath;

  @override
  Widget build(BuildContext context) {
    if (authController.isCheckingLogin) {
      return Navigator(
        key: navigatorKey,
        pages: const [
          MaterialPage(
            child: Scaffold(body: Center(child: CircularProgressIndicator())),
          ),
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    }

    if (!authController.isLoggedIn) {
      _currentPath = '/login';
      return Navigator(
        key: navigatorKey,
        pages: const [MaterialPage(child: LoginPage())],
        onPopPage: (route, result) => route.didPop(result),
      );
    }

    if (_currentPath == '/login') {
      _currentPath = '/dashboard';
    }

    final page = _buildPageForPath();

    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: AdminLayout(
            currentRoute: _currentPath,
            onNavigate: (path) {
              _currentPath = path;
              notifyListeners();
            },
            child: page,
          ),
        ),
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  Widget _buildPageForPath() {
    switch (_currentPath) {
      case '/dashboard':
        return const DashboardPage();
      case '/categories':
        return const CategoriesPage();
      case '/attributes':
        return const AttributesPage();
      case '/brands':
        return const BrandsPage();
      case '/coupons':
        return const CouponsPage();
      case '/products':
        return const ProductListPage();
      case '/orders':
        return const OrdersPage();
      case '/customers':
        return const CustomersPage();
      case '/reviews':
        return const AllReviewScreen();
      default:
        return const DashboardPage();
    }
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    _currentPath = configuration;
  }

  @override
  void dispose() {
    authController.removeListener(notifyListeners);
    super.dispose();
  }
}

class AppRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return routeInformation.uri.path.isEmpty
        ? '/login'
        : routeInformation.uri.path;
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(uri: Uri(path: configuration));
  }
}
