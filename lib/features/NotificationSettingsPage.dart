import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends State<NotificationSettingsPage> {

  bool general = true;
  bool sound = true;
  bool call = true;
  bool vibration = true;
  bool transactionChange = false;
  bool transactionNotify = false;
  bool fundNotify = false;
  bool budgetWarning = false;

  Widget buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      activeColor: const Color(0xFF1ABC9C),
      onChanged: (val) {
        setState(() {
          onChanged(val);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1ABC9C),
      body: Column(
        children: [
          const SizedBox(height: 60),

          /// HEADER
          Row(
            children: [
              const SizedBox(width: 15),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "Cài Đặt Thông Báo",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),

          const SizedBox(height: 30),

          /// BODY
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5F0),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: ListView(
                children: [
                  buildSwitch("Thông Tin Chung", general,
                          (val) => general = val),

                  buildSwitch("Âm Thanh", sound,
                          (val) => sound = val),

                  buildSwitch("Thông Báo Gọi", call,
                          (val) => call = val),

                  buildSwitch("Rung", vibration,
                          (val) => vibration = val),

                  buildSwitch("Thay Đổi Giao Dịch",
                      transactionChange,
                          (val) => transactionChange = val),

                  buildSwitch("Thông Báo Giao Dịch",
                      transactionNotify,
                          (val) => transactionNotify = val),

                  buildSwitch("Thông Báo Quỹ",
                      fundNotify,
                          (val) => fundNotify = val),

                  buildSwitch("Cảnh Báo Vượt Ngân Sách",
                      budgetWarning,
                          (val) => budgetWarning = val),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}