import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'controllers/attribute_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/brand_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/coupon_controller.dart';
import 'controllers/customer_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/product_review_controller.dart';
import 'data/services/seed_data_service.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SeedDataService.seedPhoneData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()..checkLogin()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
        ChangeNotifierProvider(create: (_) => AttributeController()),
        ChangeNotifierProvider(create: (_) => BrandController()),
        ChangeNotifierProvider(create: (_) => CouponController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => CustomerController()),
        ChangeNotifierProvider(create: (_) => ProductReviewController()),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  final AppRouteParser _routeParser = AppRouteParser();
  AppRouterDelegate? _routerDelegate;
  AuthController? _authController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AuthController>();
    if (_authController != auth) {
      _routerDelegate?.dispose();
      _authController = auth;
      _routerDelegate = AppRouterDelegate(auth);
    }
  }

  @override
  void dispose() {
    _routerDelegate?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Phone Store Admin',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F6CBD)),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        fontFamily: 'Segoe UI',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
      routerDelegate: _routerDelegate!,
      routeInformationParser: _routeParser,
    );
  }
}
