import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final isCompact = MediaQuery.of(context).size.width < 900;

    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: isCompact
          ? Builder(
              builder: (context) => IconButton(
                onPressed: Scaffold.of(context).openDrawer,
                icon: const Icon(Icons.menu_rounded),
              ),
            )
          : null,
      titleSpacing: isCompact ? 12 : 24,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: const Color(0xFFE6ECF2), height: 1),
      ),
      title: isCompact
          ? const Text(
              'Phone Store Admin',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B2430),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F8FB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search phones, orders, customers...',
                        prefixIcon: Icon(Icons.search_rounded),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const _Action(icon: Icons.language_rounded, tooltip: 'Language'),
                const _Action(
                  icon: Icons.notifications_none_rounded,
                  tooltip: 'Notifications',
                ),
                const _Action(
                  icon: Icons.settings_outlined,
                  tooltip: 'Settings',
                ),
              ],
            ),
      actions: [
        PopupMenuButton<String>(
          offset: const Offset(0, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          onSelected: (value) {
            if (value == 'logout') {
              auth.logout();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem<String>(
              value: 'profile',
              child: Text('Profile'),
            ),
            PopupMenuItem<String>(
              value: 'security',
              child: Text('Security'),
            ),
            PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
          child: const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'User Admin',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B2430),
                      ),
                    ),
                    Text(
                      'Phone manager',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF1976D2),
                  child: Text(
                    'UA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down_rounded, color: Colors.black45),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.tooltip});

  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          onPressed: () {},
          icon: Icon(icon, color: const Color(0xFF475569)),
        ),
      ),
    );
  }
}
