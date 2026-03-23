import 'package:flutter/material.dart';

import '../../data/database/models/AssetModel.dart';
import '../widgets/app_secondary_shell.dart';

class AssetDetailScreen extends StatelessWidget {
  const AssetDetailScreen({super.key});

  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  Widget build(BuildContext context) {
    final asset = ModalRoute.of(context)?.settings.arguments as AssetModel?;
    final initialValue = ((asset?.amount ?? 0) * 0.9);
    final currentValue = asset?.amount ?? 0;

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
            const Row(
              children: [
                Icon(Icons.edit_outlined, color: Color(0xFF103D3D)),
                SizedBox(width: 10),
                Icon(Icons.delete_outline, color: Color(0xFF103D3D)),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        decoration: const BoxDecoration(
          color: lightBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _valueBlock('Giá Trị Ban Đầu', initialValue, false)),
                const SizedBox(width: 24),
                Expanded(child: _valueBlock('Giá Trị Hiện Tại', currentValue, true)),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Ngày Mua',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.65),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              asset?.purchaseDate.isNotEmpty == true
                  ? asset!.purchaseDate
                  : '15/10/2024',
              style: const TextStyle(
                color: Color(0xFF1D6FFF),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: _chip('Tỷ lệ tăng giá')),
                const SizedBox(width: 10),
                Expanded(child: _chip('Tỷ lệ khấu hao')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _chip('Loại (${asset?.description ?? ''})')),
                const SizedBox(width: 10),
                Expanded(child: _chip('Kỳ hạn')),
              ],
            ),
            const SizedBox(height: 10),
            _wideChip('Ghi Chú'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 18),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: CustomPaint(painter: _BarSketchPainter()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _valueBlock(String label, double value, bool highlight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Text(
          _formatCurrency(value),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: highlight ? primary : const Color(0xFF113939),
          ),
        ),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _wideChip(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(text),
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

class _BarSketchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final teal = Paint()
      ..color = const Color(0xFF16C8A0)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final blue = Paint()
      ..color = const Color(0xFF1D6FFF)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final bars = [
      [0.18, 0.52, teal],
      [0.24, 0.36, blue],
      [0.32, 0.62, teal],
      [0.38, 0.48, blue],
      [0.48, 0.74, blue],
      [0.56, 0.56, teal],
      [0.64, 0.31, teal],
      [0.70, 0.49, blue],
      [0.80, 0.58, teal],
      [0.86, 0.43, blue],
      [0.93, 0.26, teal],
    ];

    for (final bar in bars) {
      final x = size.width * (bar[0] as double);
      final height = size.height * (bar[1] as double);
      final paint = bar[2] as Paint;
      canvas.drawLine(
        Offset(x, size.height * 0.88),
        Offset(x, size.height * 0.88 - height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
