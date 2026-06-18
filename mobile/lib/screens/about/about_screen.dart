import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang GymBuddy'), backgroundColor: theme.colorScheme.primaryContainer),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('GymBuddy', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Platform Fitness Purwokerto', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Tentang Kami', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'GymBuddy adalah platform yang menghubungkan Anda dengan personal trainer profesional di Purwokerto. '
              'Kami memudahkan Anda untuk menemukan trainer yang sesuai dengan tujuan fitness Anda, '
              'melakukan booking sesi latihan, dan melacak progres latihan Anda.',
              style: TextStyle(color: Colors.grey[700], height: 1.6),
            ),
            const SizedBox(height: 24),
            Text('Fitur Utama', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _featureItem(Icons.search, 'Cari Trainer', 'Temukan personal trainer terbaik di Purwokerto'),
            _featureItem(Icons.calendar_month, 'Booking Mudah', 'Pesan sesi latihan dengan mudah dan cepat'),
            _featureItem(Icons.trending_up, 'Tracking Progress', 'Pantau perkembangan latihan Anda'),
            _featureItem(Icons.payment, 'Pembayaran Aman', 'Bayar melalui Midtrans dengan berbagai metode'),
            const SizedBox(height: 32),
            Text('Hubungi Kami', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _contactItem(Icons.email, 'Email', 'support@gymbuddy.site'),
            _contactItem(Icons.location_on, 'Lokasi', 'Purwokerto, Jawa Tengah'),
            _contactItem(Icons.language, 'Web', 'gymbuddy.site'),
            const SizedBox(height: 24),
            Center(
              child: Text('v1.0.0  •  © 2026 GymBuddy', style: TextStyle(color: Colors.grey[500])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700], size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
