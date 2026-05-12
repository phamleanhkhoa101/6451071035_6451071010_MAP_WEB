import 'package:flutter/material.dart';

import 'admin_appbar.dart';
import 'sidebar.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout({
    super.key,
    required this.child,
    required this.onNavigate,
    required this.currentRoute,
  });

  final Widget child;
  final ValueChanged<String> onNavigate;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 900;
    final sidebar = Sidebar(
      onNavigate: onNavigate,
      currentRoute: currentRoute,
    );

    return Scaffold(
      appBar: const AdminAppBar(),
      drawer: isCompact
          ? Drawer(
              width: 280,
              child: SafeArea(child: sidebar),
            )
          : null,
      body: isCompact
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            )
          : Row(
              children: [
                sidebar,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: child,
                  ),
                ),
              ],
            ),
    );
  }
}
