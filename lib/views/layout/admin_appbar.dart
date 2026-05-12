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
              'MAP Web Admin',
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
                        hintText: 'Tìm kiếm trong hệ thống...',
                        prefixIcon: Icon(Icons.search_rounded),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                _action(Icons.language_rounded, 'Ngôn ngữ'),
                _action(Icons.notifications_none_rounded, 'Thông báo'),
                _action(Icons.settings_outlined, 'Cài đặt'),
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
              child: Text('Thông tin cá nhân'),
            ),
            PopupMenuItem<String>(
              value: 'security',
              child: Text('Bảo mật'),
            ),
            PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'logout',
              child: Text('Đăng xuất'),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: const [
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
                      'Quản trị viên',
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

  Widget _action(IconData icon, String tooltip) {
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

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
