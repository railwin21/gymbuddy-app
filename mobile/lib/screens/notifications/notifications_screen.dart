import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final _api = ApiService();
  List<dynamic> _notifications = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _loading = true);
    try {
      final res = await _api.getNotifications();
      setState(() {
        _notifications = (res['data'] as List?) ?? [];
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Gagal memuat notifikasi');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _markRead(int id) async {
    try {
      await _api.markNotificationRead(id);
      _loadNotifications();
    } catch (_) {}
  }

  IconData _getTypeIcon(String? type) {
    switch (type) {
      case 'booking': return Icons.book_online;
      case 'payment': return Icons.payment;
      case 'progress': return Icons.trending_up;
      case 'promo': return Icons.local_offer;
      default: return Icons.notifications;
    }
  }

  MaterialColor _getTypeColor(String? type) {
    switch (type) {
      case 'booking': return Colors.blue;
      case 'payment': return Colors.green;
      case 'progress': return Colors.orange;
      case 'promo': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount = _notifications.where((n) => n['is_read'] == false || n['is_read'] == 0).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(unreadCount > 0 ? 'Notifikasi ($unreadCount)' : 'Notifikasi'),
      ),
      body: _buildContent(theme),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadNotifications, child: const Text('Coba Lagi')),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('Tidak ada notifikasi', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
            const SizedBox(height: 8),
            Text('Tenang saja, kami akan memberitahu jika ada update', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          ],
        ),
      );
    }

    final unread = _notifications.where((n) => n['is_read'] == false || n['is_read'] == 0).toList();
    final read = _notifications.where((n) => n['is_read'] == true || n['is_read'] == 1).toList();

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (unread.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text('Belum Dibaca', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[800])),
                  const Spacer(),
                  Text('${unread.length}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ...unread.map((n) => _buildNotificationCard(n, theme, isUnread: true)),
            const SizedBox(height: 24),
          ],
          if (read.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Riwayat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[800])),
            ),
            ...read.map((n) => _buildNotificationCard(n, theme, isUnread: false)),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationCard(dynamic notification, ThemeData theme, {required bool isUnread}) {
    final title = notification['title'] ?? 'Notifikasi';
    final message = notification['message'] ?? '';
    final type = notification['type']?.toString();
    final createdAt = notification['created_at']?.toString();
    final id = notification['id'] ?? 0;
    final _ = notification['is_read'] == true || notification['is_read'] == 1;

    String timeStr = '--';
    try {
      final date = DateTime.parse(createdAt!);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 60) {
        timeStr = '${diff.inMinutes}m lalu';
      } else if (diff.inHours < 24) {
        timeStr = '${diff.inHours}j lalu';
      } else {
        timeStr = DateFormat('dd MMM').format(date);
      }
    } catch (_) {}

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isUnread ? Colors.blue[50] : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isUnread ? () => _markRead(id) : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: _getTypeColor(type)[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getTypeIcon(type), color: _getTypeColor(type)[700], size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(timeStr, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(message, style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              if (isUnread)
                Container(
                  width: 8, height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
