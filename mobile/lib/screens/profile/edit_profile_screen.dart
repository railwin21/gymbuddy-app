import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _api = ApiService();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _kotaController = TextEditingController();
  final _propinsiController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _kotaController.dispose();
    _propinsiController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final res = await _api.getUserProfile();
    if (res['success'] == true && res['data'] != null) {
      final u = res['data'];
      _namaController.text = u['nama'] ?? '';
      _emailController.text = u['email'] ?? '';
      _kotaController.text = u['kota'] ?? '';
      _propinsiController.text = u['propinsi'] ?? '';
    }
    setState(() => _isLoading = false);
  }

  Future<void> _save() async {
    if (_namaController.text.trim().isEmpty) return;
    setState(() => _isSaving = true);
    final res = await _api.updateProfile({
      'nama': _namaController.text.trim(),
      'email': _emailController.text.trim(),
      'kota': _kotaController.text.trim(),
      'propinsi': _propinsiController.text.trim(),
    });
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Profil berhasil diperbarui'),
          backgroundColor: Colors.green[700],
        ),
      );
      if (res['success'] == true) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: theme.colorScheme.primaryContainer,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Simpan'),
          ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(Icons.person, size: 50, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(Icons.person_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _kotaController,
                  decoration: const InputDecoration(
                    labelText: 'Kota',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _propinsiController,
                  decoration: const InputDecoration(
                    labelText: 'Provinsi',
                    prefixIcon: Icon(Icons.map),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
