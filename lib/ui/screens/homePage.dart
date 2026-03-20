import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spending_management_group4/ui/screens/NotificationPage.dart';

import '../../provider/budget_provider.dart';
import '../../provider/category_provider.dart';

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

            /// ================= TỔNG QUAN =================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF6DBE9A),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Hi, Welcome Back",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Text(
                    "Good Morning",
                    style: TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [

                      /// Tổng dư
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
// hien thu tong thu tai day
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

                      Container(height: 50,width: 1,color: Colors.white),

                      /// Tổng chi
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.call_received,size:16),
                                SizedBox(width:6),
                                Text("Tổng Chi"),
                              ],
                            ),
// hien thi tong thu tong chi tai day
                            SizedBox(height:8),

                            Text(
                              "-1,187.40 Vnd",
                              style: TextStyle(
                                fontSize:24,
                                fontWeight:FontWeight.bold,
                                color:Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height:20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: LinearProgressIndicator(
                      value: 0.3,
                      minHeight: 22,
                      backgroundColor: Colors.white70,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height:8),
// hien thi so chi so voi tong trong vi
                  const Row(
                    children: [
                      Icon(Icons.check_box,size:18),
                      SizedBox(width:6),
                      Text("30% Tổng Đã Chi."),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height:16),

            /// ================= TÌNH HÌNH THU CHI =================
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
                    style: TextStyle(
                      fontSize:18,
                      fontWeight:FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height:20),

                  /// ===== Category =====
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6DBE9A),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Row(
                      children: [

                        const Expanded(
                          child: SizedBox(height:120),
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal:12),
                          height:120,
                          width:1,
                          color:Colors.white,
                        ),

                        /// CATEGORY LIST
                        Expanded(
                          child: Consumer(
                            builder:(context,ref,child){

                              final categories = ref.watch(categoryProvider);

                              if(categories.isEmpty){
                                return const Center(
                                  child: Text("Chưa có danh mục"),
                                );
                              }

                              return Column(
                                children: categories.map((category){

                                  return ListTile(
                                    leading: const Icon(Icons.category),
                                    title: Text(category.name),
                                    subtitle: Text(category.description),
                                    trailing: Text(category.type),
                                  );

                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height:16),

            /// ================= LỊCH SỬ =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE5DD),
                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Tổng Quan Lịch Sử",
                    style: TextStyle(
                      fontSize:18,
                      fontWeight:FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height:20),

                  ...historyList.map((item){

                    bool isNegative = item["amount"] < 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical:12),
                      child: Row(
                        children: [

                          CircleAvatar(
                            radius:28,
                            backgroundColor: const Color(0xFF7EA6E0),
                            child: Icon(item["icon"],color:Colors.white),
                          ),

                          const SizedBox(width:16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children:[
                                Text(
                                  item["title"],
                                  style: const TextStyle(
                                    fontWeight:FontWeight.bold,
                                  ),
                                ),
                                Text(item["time"]),
                              ],
                            ),
                          ),

                          Text(item["type"]),

                          const SizedBox(width:16),

                          Text(
                            "${item["amount"]} Vnd",
                            style: TextStyle(
                              fontWeight:FontWeight.bold,
                              color:isNegative ? Colors.blue : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );

                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height:16),

            /// ================= BUDGET =================
            Consumer(
              builder:(context,ref,child){

                final budgets = ref.watch(budgetProvider);

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE5DD),
                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:[

                      const Text(
                        "Hạn Mức Chi Tiêu",
                        style: TextStyle(
                          fontSize:18,
                          fontWeight:FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height:16),

                      if(budgets.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Chưa có hạn mức chi tiêu"),
                          ),
                        )
                      else
                        ...budgets.map((item){

                          return Column(
                            children:[

                              Row(
                                children:[

                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6DBE9A),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(Icons.attach_money),
                                  ),

                                  const SizedBox(width:16),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children:[
                                        Text(
                                          item.budgetName,
                                          style: const TextStyle(
                                            fontWeight:FontWeight.bold,
                                          ),
                                        ),

                                        Text(
                                          "${item.startDate} - ${item.endDate}",
                                          style: const TextStyle(
                                            color:Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    "${item.amount.toStringAsFixed(0)} Vnd",
                                    style: const TextStyle(
                                      fontWeight:FontWeight.bold,
                                      color:Colors.blue,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height:12),

                              const Divider(color:Color(0xFF6DBE9A)),

                              const SizedBox(height:12),
                            ],
                          );

                        }).toList(),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height:16),
          ],
        ),
      ),
    );
  }
}