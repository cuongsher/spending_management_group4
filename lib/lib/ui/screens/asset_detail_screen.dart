import 'package:flutter/material.dart';

import '../../data/database/models/AssetModel.dart';
import '../widgets/app_secondary_shell.dart';

class AssetDetailScreen extends StatelessWidget {
  const AssetDetailScreen({super.key});

  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  Widget build(BuildContext context) {
    final asset =
    ModalRoute.of(context)?.settings.arguments as AssetModel?;

    final assets = asset != null ? [asset] : [];

    return AppSecondaryShell(
      primaryColor: primary,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 20, 18),
        child: Row(
          children: [
            const BackButton(color: Colors.white),
            Expanded(
              child: Text(
                asset?.assetName ?? 'Tài Sản',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF113939),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: lightBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ListView.builder(
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final asset = assets[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== TÊN TÀI SẢN =====
                _buildField("Tên Tài Sản", asset.assetName),

                const SizedBox(height: 16),

                // ===== GIÁ TRỊ =====
                _buildField("Số Tiền", _formatCurrency(asset.amount)),

                const SizedBox(height: 16),

                // ===== NGÀY =====
                _buildField(
                  "Ngày Mua",
                  asset.purchaseDate.isNotEmpty
                      ? asset.purchaseDate
                      : '23/03/2026',
                ),

                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F4F4F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFDCE8DF), // xanh nhạt giống ảnh
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2F4F4F),
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    final integer = value.round().toString();
    final chars = integer.split('').reversed.toList();
    final buffer = StringBuffer();
    for (var i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(chars[i]);
    }
    return buffer.toString().split('').reversed.join();
  }
}

