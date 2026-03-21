import 'package:flutter/material.dart';

// ─── Header ───────────────────────────────────────────────────────────────────

class GhiChepHeader extends StatelessWidget {
  final String title;
  const GhiChepHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 0, 12, 16),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            Expanded(
              child: Center(
                child: Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Field Label ──────────────────────────────────────────────────────────────

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black87)),
    );
  }
}

// ─── Input Field ──────────────────────────────────────────────────────────────

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const InputField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}

// ─── Dropdown Field ───────────────────────────────────────────────────────────

class DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ─── Date Field ───────────────────────────────────────────────────────────────

class DateField extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  final String Function(DateTime) fmt;

  const DateField({super.key, required this.date, required this.onTap, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(fmt(date),
                  style: const TextStyle(fontSize: 15, color: Colors.black87)),
            ),
            Icon(Icons.calendar_month_outlined, color: scheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Action Bar ────────────────────────────────────────────────────────

class BottomActionBar extends StatelessWidget {
  final VoidCallback onDelete, onCamera;
  final VoidCallback? onSave;
  final bool isLoading;

  const BottomActionBar({
    super.key,
    required this.onDelete,
    required this.onCamera,
    required this.onSave,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                minimumSize: const Size(0, 48),
                elevation: 0,
              ),
              child: const Text('Xóa', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onCamera,
            child: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.black54),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                minimumSize: const Size(0, 48),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Lưu', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Scanned Item ─────────────────────────────────────────────────────────────

class ScannedItem {
  final String name, category;
  final int unitPrice;
  final double qty;
  const ScannedItem({required this.name, required this.category, required this.unitPrice, required this.qty});
}

class ScannedItemTile extends StatelessWidget {
  final ScannedItem item;
  const ScannedItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text('Đơn giá: ${item.unitPrice}',
                    style: const TextStyle(fontSize: 11, color: Colors.black54)),
                Text('Phân Loại: ${item.category}',
                    style: const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          Text('slg:${item.qty.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}
