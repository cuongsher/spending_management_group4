import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "title": "Nhắc Nhở",
        "content": "Mua gì thì ghi lại nhé tình yêu ơi!",
        "time": "17:00 - 24/04",
      },
      {
        "title": "Thông Báo Mới",
        "content": "Cập nhật để sử dụng tiện ích thú vị",
        "time": "17:00 - 24/04",
      },
      {
        "title": "Giao Dịch",
        "content": "Hôm qua bạn đã mua cái quần 100k!",
        "time": "17:00 - 24/04",
      },
      {
        "title": "Báo Cáo",
        "content": "Báo cáo tuần qua mua sắm quá lố",
        "time": "17:00 - 24/04",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Thông Báo")),
      body: Container(
        color: const Color(0xFFDCE5DD),
        padding: const EdgeInsets.all(16),

        /// ListView giúp kéo lên kéo xuống
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  /// Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications),
                  ),

                  const SizedBox(width: 12),

                  /// Nội dung
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(item["content"]!),
                        const SizedBox(height: 4),
                        Text(
                          item["time"]!,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
