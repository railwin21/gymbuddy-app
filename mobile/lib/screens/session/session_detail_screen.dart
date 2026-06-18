import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/api_service.dart';

class SessionDetailScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  ConsumerState<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends ConsumerState<SessionDetailScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _session;
  bool _isLoading = true;
  String? _error;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    setState(() => _isLoading = true);
    final res = await _api.getSessionDetail(widget.sessionId);
    if (res['success'] == true || res['data'] != null) {
      setState(() { _session = res['data'] ?? res; _isLoading = false; });
    } else {
      setState(() { _error = res['message'] ?? 'Gagal memuat detail sesi'; _isLoading = false; });
    }
  }

  Future<void> _bookSession() async {
    setState(() => _isBooking = true);
    final res = await _api.createBooking(widget.sessionId);
    setState(() => _isBooking = false);
    if (res['success'] == true || res['data'] != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Booking berhasil!'), backgroundColor: Colors.green[700]),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Gagal booking'), backgroundColor: Colors.red[700]),
        );
      }
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'TBD';
    final dt = DateTime.parse(dateStr);
    return '${DateFormat('EEEE, dd MMM yyyy', 'id').format(dt)}  •  ${DateFormat('HH:mm').format(dt)}';
  }

  String _formatRupiah(dynamic amount) {
    final value = (amount is int || amount is double) ? amount : double.tryParse(amount.toString()) ?? 0;
    return NumberFormat('#,###', 'id_ID').format((value as num).toInt());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Sesi'), backgroundColor: theme.colorScheme.primaryContainer),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
          ? Center(child: Text(_error!, style: TextStyle(color: Colors.red[700])))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_session?['title'] ?? '', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(_session?['status'] ?? 'scheduled'),
                    backgroundColor: Colors.blue[50],
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _infoRow(Icons.calendar_today, 'Waktu', _formatDate(_session?['start_time'])),
                          const Divider(),
                          _infoRow(Icons.access_time, 'Durasi', _session?['end_time'] != null ? '${DateTime.parse(_session!['end_time']).difference(DateTime.parse(_session!['start_time'])).inMinutes} menit' : '1 jam'),
                          const Divider(),
                          _infoRow(Icons.person, 'Trainer', _session?['trainer_name'] ?? ''),
                          const Divider(),
                          _trainerPhotoRow(_session?['trainer_photo'] ?? '', _session?['trainer_name'] ?? ''),
                          const Divider(),
                          _infoRow(Icons.people, 'Max Peserta', '${_session?['max_participants'] ?? 1} orang'),
                          const Divider(),
                          _infoRow(Icons.money, 'Harga', 'Rp${_formatRupiah(_session?['price'] ?? 0)}'),
                        ],
                      ),
                    ),
                  ),
                  if (_session?['deskripsi'] != null) ...[
                    const SizedBox(height: 20),
                    Text('Deskripsi', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_session!['deskripsi'], style: TextStyle(color: Colors.grey[700], height: 1.5)),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isBooking ? null : _bookSession,
                      icon: _isBooking
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.calendar_today),
                      label: Text(_isBooking ? 'Memproses...' : 'Ambil Sesi Ini'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(width: 100, child: Text(label, style: TextStyle(color: Colors.grey[600]))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _trainerPhotoRow(String trainerPhoto, String trainerName) {
    final baseUrl = ApiService.baseUrl.replaceAll('/api', '');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: trainerPhoto.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: '$baseUrl/$trainerPhoto',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(width: 40, height: 40, color: Colors.grey[200]),
                    errorWidget: (ctx, url, err) => Container(
                      width: 40,
                      height: 40,
                      color: Theme.of(context).colorScheme.primary.withAlpha(25),
                      child: Center(
                        child: Text(trainerName[0].toUpperCase(), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(trainerName.isNotEmpty ? trainerName[0].toUpperCase() : 'T', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 100, child: Text('Foto Trainer', style: TextStyle(color: Colors.grey[600]))),
          Expanded(child: Text(trainerName, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
