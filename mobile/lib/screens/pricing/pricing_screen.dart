import 'package:flutter/material.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Harga Sesi'), backgroundColor: theme.colorScheme.primaryContainer),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Paket', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Sesi latihan dengan personal trainer profesional', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            const SizedBox(height: 24),

            _pricingCard(
              context,
              icon: Icons.person,
              title: 'Private Session',
              price: 'Rp75.000 - 120.000',
              features: ['1-on-1 dengan trainer', 'Program latihan personal', 'Fleksibel jadwal', 'Koreksi form detail'],
              color: Colors.blue,
              isPopular: false,
            ),
            const SizedBox(height: 16),

            _pricingCard(
              context,
              icon: Icons.people,
              title: 'Group Session',
              price: 'Rp50.000 - 90.000',
              features: ['Latihan bersama (3-5 orang)', 'Harga lebih terjangkau', 'Motivasi berkelompok', 'Waktu tetap setiap minggu'],
              color: Colors.green,
              isPopular: true,
            ),
            const SizedBox(height: 16),

            _pricingCard(
              context,
              icon: Icons.star,
              title: 'Paket Bulanan',
              price: 'Rp300.000 - 500.000',
              features: ['4-8 sesi per bulan', 'Diskon 20%', 'Prioritas booking', 'Progress tracking'],
              color: Colors.orange,
              isPopular: false,
            ),

            const SizedBox(height: 32),
            Text('Metode Pembayaran', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _paymentChip(Icons.credit_card, 'Kartu Kredit'),
                _paymentChip(Icons.account_balance, 'Bank Transfer'),
                _paymentChip(Icons.phone_android, 'GoPay'),
                _paymentChip(Icons.phone_android, 'OVO'),
                _paymentChip(Icons.phone_android, 'DANA'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pricingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String price,
    required List<String> features,
    required Color color,
    required bool isPopular,
  }) {
    return Card(
      elevation: isPopular ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isPopular ? BorderSide(color: color, width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          if (isPopular) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('POPULER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
                            ),
                          ],
                        ],
                      ),
                      Text(price, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: Colors.green[600]),
                  const SizedBox(width: 8),
                  Text(f, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _paymentChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      side: BorderSide.none,
      backgroundColor: Colors.grey[100],
    );
  }
}
