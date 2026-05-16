import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:map_web_6451071035_6451071010/controllers/brand_controller.dart';
import 'package:map_web_6451071035_6451071010/controllers/product_controller.dart';

import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'data/services/seed_data_service.dart';

import 'controllers/auth_controller.dart';

import 'controllers/category_controller.dart';

import 'controllers/attribute_controller.dart';

import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:
  DefaultFirebaseOptions.currentPlatform);

  // Seed dữ liệu mẫu vào Firestore nếu chưa có
  final hasData = await SeedDataService.hasRequiredSeedData();
  if (!hasData) {
    await SeedDataService.seedPhoneData();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>
        AuthController()..checkLogin()),

        ChangeNotifierProvider(create: (_) => CategoryController()),
        ChangeNotifierProvider(create: (_) => ProductController()),

        ChangeNotifierProvider(create: (_) => AttributeController()),
        ChangeNotifierProvider(create: (_) => BrandController()),
      ],
      child: Builder(
        builder: (context) {
          final auth = context.watch<AuthController>();

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,

            //  ADD THIS BLOCK
            localizationsDelegates: const [
              FlutterQuillLocalizations.delegate, // FIX LỖI
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('vi')],

            routerDelegate: AppRouterDelegate(auth),
            routeInformationParser: AppRouteParser(),
          );
        },
      ),
    );
  }
}