import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import 'admin_drawer.dart';

class AdminTrainersScreen extends ConsumerStatefulWidget {
  const AdminTrainersScreen({super.key});

  @override
  ConsumerState<AdminTrainersScreen> createState() => _AdminTrainersScreenState();
}

class _AdminTrainersScreenState extends ConsumerState<AdminTrainersScreen> {
  final _api = ApiService();
  List<dynamic> _trainers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrainers();
  }

  Future<void> _loadTrainers() async {
    setState(() => _isLoading = true);
    final res = await _api.getTrainers();
    if (res['success'] == true || res['data'] != null) {
      final data = res['data'] as List<dynamic>? ?? [];
      setState(() { _trainers = data; _isLoading = false; });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Trainer'), backgroundColor: theme.colorScheme.primaryContainer),
      drawer: const AdminDrawer(),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _trainers.isEmpty
          ? const Center(child: Text('Tidak ada trainer'))
          : RefreshIndicator(
              onRefresh: _loadTrainers,
              child: ListView.builder(
                itemCount: _trainers.length,
                itemBuilder: (ctx, i) {
                  final t = _trainers[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          (t['nama'] ?? '?').toString().substring(0, 1).toUpperCase(),
                          style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(t['nama'] ?? 'Unknown'),
                      subtitle: Text('${t['spesialisasi'] ?? 'No spesialisasi'}  •  ${t['kota'] ?? ''}'),
                      trailing: Chip(
                        label: Text(t['role'] ?? 'trainer', style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.blue[50],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
