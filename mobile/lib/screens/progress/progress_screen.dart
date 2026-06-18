import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  final _api = ApiService();
  final _activityController = TextEditingController();
  final _noteController = TextEditingController();
  final _durationController = TextEditingController();
  List<dynamic> _progressList = [];
  bool _loading = true;
  bool _showForm = false;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  void dispose() {
    _activityController.dispose();
    _noteController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    setState(() => _loading = true);
    try {
      final res = await _api.getMyProgress();
      final data = res['data'] ?? [];
      setState(() {
        _progressList = (data as List?) ?? [];
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Gagal memuat data progress');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _addProgress() async {
    final activity = _activityController.text.trim();
    final durationText = _durationController.text.trim();
    if (activity.isEmpty || durationText.isEmpty) return;

    setState(() => _saving = true);
    try {
      await _api.addProgress({
        'activity': activity,
        'duration': int.tryParse(durationText) ?? 30,
        'note': _noteController.text.trim(),
      });
      _activityController.clear();
      _durationController.clear();
      _noteController.clear();
      setState(() => _showForm = false);
      _loadProgress();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress tersimpan!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan progress'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _saving = false);
    }
  }

  int get _todayCount => _progressList.where((p) {
    final date = p['recorded_at']?.toString();
    if (date == null) return false;
    try {
      return DateTime.parse(date).day == DateTime.now().day;
    } catch (_) {
      return false;
    }
  }).length;

  int get _totalDuration => _progressList.fold<int>(0, (sum, p) {
    final d = p['duration'];
    return sum + (int.tryParse(d?.toString() ?? '0') ?? 0);
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracker'),
        actions: [
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProgress,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Stats cards
                  Row(
                    children: [
                      _buildStatCard('Hari Ini', '$_todayCount', Icons.today, Colors.red, theme),
                      const SizedBox(width: 12),
                      _buildStatCard('Total Latihan', '${_progressList.length}', Icons.fitness_center, Colors.blue, theme),
                      const SizedBox(width: 12),
                      _buildStatCard('Durasi', '${_totalDuration}m', Icons.timer, Colors.green, theme),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Add form
                  if (_showForm) _buildAddForm(theme),

                  // Error
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(_error!, style: TextStyle(color: Colors.red[700], fontSize: 13)),
                    ),

                  // Empty state
                  if (_progressList.isEmpty && !_showForm)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.fitness_center, size: 48, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text('Belum ada data latihan', style: TextStyle(color: Colors.grey[500])),
                            const SizedBox(height: 8),
                            Text('Tekan + untuk mencatat latihan baru', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          ],
                        ),
                      ),
                    ),

                  // Progress list
                  if (_progressList.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Riwayat Latihan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._progressList.map((p) => _buildProgressCard(p, theme)),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, MaterialColor color, ThemeData theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: color[700], size: 22),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color[800])),
            Text(label, style: TextStyle(fontSize: 10, color: color[600], fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddForm(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Catat Latihan Baru', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
          const SizedBox(height: 12),
          TextField(
            controller: _activityController,
            decoration: const InputDecoration(
              labelText: 'Nama Latihan',
              hintText: 'Bench Press, Squat, dll',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Durasi (menit)',
              hintText: '60',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Catatan (opsional)',
              hintText: 'Terasa ringan, progres bagus...',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _addProgress,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: _saving
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('SIMPAN'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(dynamic progress, ThemeData theme) {
    final activity = progress['activity'] ?? 'Latihan';
    final duration = progress['duration'] ?? 0;
    final note = progress['note'] ?? '';
    String dateStr = '--';
    try {
      final date = DateTime.parse(progress['recorded_at']?.toString() ?? '');
      dateStr = DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (_) {}

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.fitness_center, color: Colors.red[700], size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text('$duration menit', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(dateStr, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                    ],
                  ),
                  if (note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('"$note"', style: TextStyle(color: Colors.grey[500], fontSize: 12, fontStyle: FontStyle.italic)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
