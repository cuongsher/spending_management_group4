import 'package:flutter/material.dart';
class HistoryItem {
  final IconData icon;
  final String title;
  final String time;
  final String type; // Mỗi tháng / Mỗi ngày / Định kì
  final double amount;

  HistoryItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.type,
    required this.amount,
  });
}