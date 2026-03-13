import 'package:flutter/material.dart';

class ShoppingItem extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;

  const ShoppingItem({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [

          /// Icon bên trái
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 35, color: Colors.white),
          ),

          const SizedBox(width: 15),

          /// Nội dung
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(text: "Lần mua gần nhất: "),
                      TextSpan(
                        text: time,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Mũi tên bên phải
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}