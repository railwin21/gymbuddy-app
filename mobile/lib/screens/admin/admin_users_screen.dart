import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _api = ApiService();
  List<dynamic> _users = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers({String? search}) async {
    setState(() => _isLoading = true);
    final res = await _api.adminGetUsers(limit: 100);
    if (res['success'] == true || res['data'] != null) {
      var data = res['data'] as List<dynamic>? ?? [];
      if (search != null && search.isNotEmpty) {
        data = data.where((u) =>
          (u['nama'] ?? '').toString().toLowerCase().contains(search.toLowerCase()) ||
          (u['email'] ?? '').toString().toLowerCase().contains(search.toLowerCase())
        ).toList();
      }
      setState(() { _users = data; _isLoading = false; _error = null; });
    } else {
      setState(() { _isLoading = false; _error = res['message'] ?? 'Gagal memuat data'; });
    }
  }

  Future<void> _deleteUser(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus User'),
        content: const Text('Yakin ingin menghapus user ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await _api.adminDeleteUser(id);
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Users'), backgroundColor: theme.colorScheme.primaryContainer),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama atau email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchController.clear(); _loadUsers(); })
                  : null,
              ),
              onChanged: (v) { _loadUsers(search: v); },
            ),
          ),
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                ? Center(child: Text(_error!, style: TextStyle(color: Colors.red[700])))
                : _users.isEmpty
                  ? const Center(child: Text('Tidak ada user'))
                  : RefreshIndicator(
                      onRefresh: () => _loadUsers(),
                      child: ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (ctx, i) {
                          final u = _users[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: u['role'] == 'admin' ? Colors.red[100] : u['role'] == 'trainer' ? Colors.blue[100] : Colors.green[100],
                              child: Icon(
                                u['role'] == 'admin' ? Icons.admin_panel_settings : u['role'] == 'trainer' ? Icons.fitness_center : Icons.person,
                                color: u['role'] == 'admin' ? Colors.red[700] : u['role'] == 'trainer' ? Colors.blue[700] : Colors.green[700],
                              ),
                            ),
                            title: Text(u['nama'] ?? 'Unknown'),
                            subtitle: Text('${u['email'] ?? ''}  •  ${u['role'] ?? ''}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: u['role'] != 'admin' ? () => _deleteUser(u['id']) : null,
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
