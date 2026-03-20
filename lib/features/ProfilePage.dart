import 'package:flutter/material.dart';
import 'EditProfilePage.dart';
import 'SecurityPage.dart';
import 'SettingsPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Nguyễn Hoàng";
  String phone = "+84 555 555 55";
  String email = "example@example.com";
  bool notify = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: Column(
        children: [

             SafeArea(
               child: Padding(//khoag cach 4 canh
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15), //khoang cach hai ben/tren duoi
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.arrow_back, color: Colors.black),
                    Text(
                      "Profile",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.notifications_none, color: Colors.black),
                  ],
                ),
                           ),
             ),

          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFFDCE5DD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text("ID: 25030024"),
                  const SizedBox(height: 40),
                  buildItem(context, Icons.person_outline,
                      "Thông Tin Cá Nhân"),
                  buildItem(context, Icons.shield_outlined, "Bảo Mật"),
                  buildItem(context, Icons.settings, "Cài Đặt"),
                  buildItem(context, Icons.help_outline, "Trợ Giúp"),
                  buildItem(context, Icons.logout, "Đăng Xuất"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(
      BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: GestureDetector(
        onTap: () async {
          if (title == "Thông Tin Cá Nhân") {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(
                  name: name,
                  phone: phone,
                  email: email,
                  notify: notify,
                  darkMode: darkMode,
                ),
              ),
            );

            if (result != null) {
              setState(() {
                name = result["name"];
                phone = result["phone"];
                email = result["email"];
                notify = result["notify"];
                darkMode = result["darkMode"];
              });
            }
          } else if (title == "Bảo Mật") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SecurityPage(),
              ),
            );
          } else if (title == "Cài Đặt") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$title đang được phát triển")),
            );
          }
        },
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF00D09E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 20),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}