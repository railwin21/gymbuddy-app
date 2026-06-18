import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class AdminPromoScreen extends ConsumerStatefulWidget {
  const AdminPromoScreen({super.key});

  @override
  ConsumerState<AdminPromoScreen> createState() => _AdminPromoScreenState();
}

class _AdminPromoScreenState extends ConsumerState<AdminPromoScreen> {
  final _api = ApiService();
  List<dynamic> _promos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPromos();
  }

  Future<void> _loadPromos() async {
    setState(() => _isLoading = true);
    try {
      final res = await _api.adminGetPromos();
      if (res['success'] == true || res['data'] != null) {
        setState(() { _promos = res['data'] as List<dynamic>? ?? []; _isLoading = false; });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _formatRupiah(dynamic amount) {
    final value = (amount is int || amount is double) ? amount : double.tryParse(amount.toString()) ?? 0;
    return NumberFormat('#,###', 'id_ID').format((value as num).toInt());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Promo & Voucher'), backgroundColor: theme.colorScheme.primaryContainer),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _promos.isEmpty
          ? const Center(child: Text('Belum ada promo'))
          : RefreshIndicator(
              onRefresh: _loadPromos,
              child: ListView.builder(
                itemCount: _promos.length,
                itemBuilder: (ctx, i) {
                  final p = _promos[i];
                  final isActive = p['is_active'] == 1;
                  final tanggalSelesai = p['tanggal_selesai'] != null
                    ? DateFormat('dd MMM yyyy').format(DateTime.parse(p['tanggal_selesai']))
                    : 'No expiry';
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isActive ? Colors.green[100] : Colors.grey[100],
                        child: Icon(Icons.discount, color: isActive ? Colors.green[700] : Colors.grey),
                      ),
                      title: Text(p['judul'] ?? ''),
                      subtitle: Text('Kode: ${p['kode'] ?? ''}  •  Rp${_formatRupiah(p['nilai'])}  •  $tanggalSelesai'),
                      trailing: Chip(
                        label: Text(isActive ? 'Active' : 'Inactive', style: const TextStyle(fontSize: 11)),
                        backgroundColor: isActive ? Colors.green[50] : Colors.grey[100],
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
