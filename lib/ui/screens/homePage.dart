import 'package:flutter/material.dart';
import 'package:spending_management_group4/data/database/models/PiePainter.dart';
import 'package:spending_management_group4/data/database/models/Category_Item.dart';
import 'package:spending_management_group4/data/database/models/BudgetItem.dart';
import 'package:spending_management_group4/ui/screens/NotificationPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> historyList = [
    {
      "icon": Icons.layers,
      "title": "Lương",
      "time": "18:27 - 30/04",
      "type": "Mỗi tháng",
      "amount": 4000.00,
    },
    {
      "icon": Icons.fastfood,
      "title": "Ăn Uống",
      "time": "17:00 - 24/04",
      "type": "Mỗi ngày",
      "amount": -10000.00,
    },
    {
      "icon": Icons.key,
      "title": "AHIHI DO NGOC",
      "time": "8:30 - 15/04",
      "type": "Định kì",
      "amount": -67440.00,
    },
  ];
  final List<BudgetItem> budgetList = [
    BudgetItem(title: "Ăn Uống", date: "01/04 - 30/04", amount: 100),
    BudgetItem(title: "Mua Sắm", date: "01/04 - 30/04", amount: 100),
    BudgetItem(title: "Học Tập", date: "01/04 - 30/04", amount: 100),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Tổng quan
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF6DBE9A), // xanh giống hình
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hi, Welcome Back",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    "Good Morning",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 25),

                  /// ===== Row Tổng Dư / Tổng Chi =====
                  Row(
                    children: [
                      /// Tổng Dư
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.call_made, size: 16),
                                SizedBox(width: 6),
                                Text("Tổng Dư"),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              "7,783.00 Vnd",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Divider dọc
                      Container(height: 50, width: 1, color: Colors.white70),

                      /// Tổng Chi
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.call_received, size: 16),
                                SizedBox(width: 6),
                                Text("Tổng Chi"),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              "-1,187.40 Vnd",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ===== Progress Bar =====
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: LinearProgressIndicator(
                      value: 0.3,
                      minHeight: 22,
                      backgroundColor: Colors.white70,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Row(
                    children: [
                      Icon(Icons.check_box, size: 18),
                      SizedBox(width: 6),
                      Text("30% Tổng Đã Chi.", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Tình hình thu chi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE5EAE6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tình Hình Thu Chi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  /// ===== CARD 1 (Bar chart + tổng thu chi) =====
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6DBE9A),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        /// Fake bar chart
                        Expanded(
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.purple,
                                width: 3,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                _Bar(height: 40),
                                _Bar(height: 90),
                                _Bar(height: 60),
                              ],
                            ),
                          ),
                        ),

                        /// Divider
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          height: 120,
                          width: 1,
                          color: Colors.white,
                        ),

                        /// Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
                                children: [
                                  Icon(Icons.north_east),
                                  SizedBox(width: 8),
                                  Text("Tổng Thu"),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                "\$4,000.00",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.south_east),
                                  SizedBox(width: 8),
                                  Text("Tổng Chi"),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                "-\$100.00",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Divider(color: Colors.white),
                              SizedBox(height: 6),
                              Center(
                                child: Column(
                                  children: [
                                    Text("Chênh Lệch"),
                                    SizedBox(height: 4),
                                    Text(
                                      "-\$100.00",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ===== CARD 2 (Pie chart + danh mục %) =====
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6DBE9A),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        /// Fake pie chart
                        Expanded(
                          child: SizedBox(
                            height: 120,
                            child: CustomPaint(painter: PiePainter()),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          height: 120,
                          width: 1,
                          color: Colors.white,
                        ),

                        /// Category list
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              CategoryItem("Đầu tư", "30%"),
                              CategoryItem("Ăn Uống", "30%"),
                              CategoryItem("Vui Chơi", "10%"),
                              CategoryItem("Sinh Hoạt", "30%"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Tổng quan lịch sử
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE5DD),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Tiêu đề
                  const Text(
                    "Tổng Quan Lịch Sử",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  /// ===== Tabs =====
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8D7CC),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTab("Hôm nay", false),
                        buildTab("Tuần này", false),
                        buildTab("Tháng này", true), // đang chọn
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ===== Danh sách =====
                  ...historyList.map((item) {
                    bool isNegative = item["amount"] < 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          /// Icon
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFF7EA6E0),
                            child: Icon(item["icon"], color: Colors.white),
                          ),

                          const SizedBox(width: 16),

                          /// Title + Time
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["time"],
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),

                          /// Type
                          Text(item["type"]),

                          const SizedBox(width: 16),

                          /// Amount
                          Text(
                            "${item["amount"]} Vnd",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isNegative ? Colors.blue : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Hạn mức chi tiêu
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE5DD),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Tiêu đề
                  const Text(
                    "Hạn Mức Chi Tiêu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  /// Danh sách
                  ...budgetList.map((item) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            /// Icon $
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6DBE9A),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.attach_money,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(width: 16),

                            /// Title + Date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.date,
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),

                            /// Amount
                            Text(
                              "${item.amount.toStringAsFixed(2)} Vnd",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// Divider xanh
                        const Divider(color: Color(0xFF6DBE9A), thickness: 1),

                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  const _Bar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

Widget buildTab(String title, bool isSelected) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6DBE9A) : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.black : Colors.black54,
        ),
      ),
    ),
  );
}
