import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';

class AdminFaqScreen extends ConsumerStatefulWidget {
  const AdminFaqScreen({super.key});

  @override
  ConsumerState<AdminFaqScreen> createState() => _AdminFaqScreenState();
}

class _AdminFaqScreenState extends ConsumerState<AdminFaqScreen> {
  final _api = ApiService();
  List<dynamic> _faqs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  Future<void> _loadFaqs() async {
    setState(() => _isLoading = true);
    final res = await _api.getFaq();
    if (res['success'] == true || res['data'] != null) {
      setState(() { _faqs = res['data'] as List<dynamic>? ?? []; _isLoading = false; });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ'), backgroundColor: theme.colorScheme.primaryContainer),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _faqs.isEmpty
          ? const Center(child: Text('Belum ada FAQ'))
          : RefreshIndicator(
              onRefresh: _loadFaqs,
              child: ListView.builder(
                itemCount: _faqs.length,
                itemBuilder: (ctx, i) {
                  final f = _faqs[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[50],
                        child: const Icon(Icons.help_outline, color: Colors.blue),
                      ),
                      title: Text(f['pertanyaan'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(f['kategori'] ?? 'umum', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(f['jawaban'] ?? '', style: TextStyle(color: Colors.grey[800], height: 1.5)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
