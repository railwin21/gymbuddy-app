import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';

void showProfileMenu(BuildContext context, WidgetRef ref) {
  final auth = ref.read(authProvider);
  showModalBottomSheet(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                (auth.user?['nama'] ?? 'U').toString()[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(auth.user?['nama'] ?? 'User'),
            subtitle: Text(auth.user?['email'] ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Lihat Profil'),
            onTap: () {
              Navigator.pop(ctx);
              context.push('/profile');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Keluar'),
            onTap: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pop(ctx);
              context.go('/login');
            },
          ),
        ],
      ),
    ),
  );
}
