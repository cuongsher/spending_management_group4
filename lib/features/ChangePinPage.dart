import 'package:flutter/material.dart';
import 'SuccessPage.dart';

class ChangePinPage extends StatefulWidget {

  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  bool eyes = true ;

  Widget buildField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(

          obscureText: eyes, //an/hiện text
          decoration: InputDecoration(
            suffix: IconButton(onPressed: (){
              setState(() {
                eyes = !eyes;
              });
            }, icon: eyes == true? Icon(Icons.remove_red_eye_rounded):Icon(Icons.remove_red_eye_outlined)),
            filled: true,
            fillColor: const Color(0xFFD8EDE4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1ABC9C),
      body: Column(
        children: [
          const SizedBox(height: 60),

          const Text(
            "Change Pin",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5F0),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  buildField("Mật Khẩu Hiện Tại"),
                  buildField("Mật Khẩu Mới"),
                  buildField("Xác Nhận Mật Khẩu"),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1ABC9C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessPage(
                            message: "Thay Đổi Mã Thành Công",
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Thay Đổi Mã",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}