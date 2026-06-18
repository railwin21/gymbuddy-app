import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class AdminArticlesScreen extends ConsumerStatefulWidget {
  const AdminArticlesScreen({super.key});

  @override
  ConsumerState<AdminArticlesScreen> createState() => _AdminArticlesScreenState();
}

class _AdminArticlesScreenState extends ConsumerState<AdminArticlesScreen> {
  final _api = ApiService();
  List<dynamic> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);
    final res = await _api.getArticles(limit: 50);
    if (res['success'] == true || res['data'] != null) {
      setState(() { _articles = res['data'] as List<dynamic>? ?? []; _isLoading = false; });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Artikel'), backgroundColor: theme.colorScheme.primaryContainer),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _articles.isEmpty
          ? const Center(child: Text('Belum ada artikel'))
          : RefreshIndicator(
              onRefresh: _loadArticles,
              child: ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (ctx, i) {
                  final a = _articles[i];
                  final published = a['published_at'] != null
                    ? DateFormat('dd MMM yyyy').format(DateTime.parse(a['published_at']))
                    : 'Draft';
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      title: Text(a['title'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${a['kategori'] ?? ''}  •  $published'),
                      trailing: Chip(
                        label: Text(a['is_published'] == 1 ? 'Published' : 'Draft', style: const TextStyle(fontSize: 11)),
                        backgroundColor: a['is_published'] == 1 ? Colors.green[50] : Colors.orange[50],
                        side: BorderSide.none,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
