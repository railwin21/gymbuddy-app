import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_provider.dart';

class AdminDrawer extends ConsumerWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final theme = Theme.of(context);
    final currentRoute = GoRouterState.of(context).matchedLocation;

    return Drawer(
      child: Column(
        children: [
          // Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            accountName: Text(auth.user?['nama'] ?? 'Admin GymBuddy', style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(auth.user?['email'] ?? 'admin@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (auth.user?['nama'] ?? 'A').toString()[0].toUpperCase(),
                style: TextStyle(color: theme.colorScheme.primary, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerTile(
                  context,
                  title: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  route: '/admin',
                  currentRoute: currentRoute,
                ),
                _drawerTile(
                  context,
                  title: 'Kelola Users',
                  icon: Icons.people_outline,
                  route: '/admin/users',
                  currentRoute: currentRoute,
                ),
                _drawerTile(
                  context,
                  title: 'Kelola Trainer',
                  icon: Icons.fitness_center_outlined,
                  route: '/admin/trainers',
                  currentRoute: currentRoute,
                ),
                _drawerTile(
                  context,
                  title: 'Kelola Booking',
                  icon: Icons.book_online_outlined,
                  route: '/admin/bookings',
                  currentRoute: currentRoute,
                ),
                _drawerTile(
                  context,
                  title: 'Kelola Artikel',
                  icon: Icons.article_outlined,
                  route: '/admin/articles',
                  currentRoute: currentRoute,
                ),
                _drawerTile(
                  context,
                  title: 'Kelola Promo',
                  icon: Icons.discount_outlined,
                  route: '/admin/promo',
                  currentRoute: currentRoute,
                ),
                _drawerTile(
                  context,
                  title: 'Kelola FAQ',
                  icon: Icons.help_outline,
                  route: '/admin/faq',
                  currentRoute: currentRoute,
                ),
              ],
            ),
          ),

          const Divider(),

          // Footer items
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: const Text('Kembali ke User'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Keluar', style: TextStyle(color: Colors.red)),
            onTap: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pop(context);
              context.go('/login');
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _drawerTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
    required String currentRoute,
  }) {
    final isActive = currentRoute == route;
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: isActive ? theme.colorScheme.primary : Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? theme.colorScheme.primary : Colors.grey[800],
        ),
      ),
      selected: isActive,
      selectedTileColor: theme.colorScheme.primary.withAlpha(20),
      onTap: () {
        Navigator.pop(context); // Close drawer
        context.go(route);
      },
    );
  }
}
