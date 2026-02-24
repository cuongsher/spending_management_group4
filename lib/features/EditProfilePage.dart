import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final bool notify;
  final bool darkMode;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.notify,
    required this.darkMode,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  late bool notify;
  late bool darkMode;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);
    notify = widget.notify;
    darkMode = widget.darkMode;
  }

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF19C49B);
    const bodyColor = Color(0xFFDFF3EC);

    return Scaffold(
      backgroundColor: mainGreen,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          /// HEADER
          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Thông Tin Cá Nhân",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),
          ),

          /// BODY
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: const BoxDecoration(
                color: bodyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Avatar
                    const Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 40, color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Center(
                      child: Text(
                        nameController.text,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),

                    const Center(child: Text("ID: 25030024")),

                    const SizedBox(height: 20),

                    const Text(
                      "Cài Đặt Cá Nhân",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 15),

                    buildField("Tên", nameController),

                    buildField(
                      "Số Điện Thoại",
                      phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),

                    buildField(
                      "Email",
                      emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 10),

                    buildSwitch("Thông Báo Đẩy", notify,
                            (v) => setState(() => notify = v)),

                    buildSwitch("Giao Diện Tối", darkMode,
                            (v) => setState(() => darkMode = v)),

                    const SizedBox(height: 20),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, {
                            "name": nameController.text,
                            "phone": phoneController.text,
                            "email": emailController.text,
                            "notify": notify,
                            "darkMode": darkMode,
                          });
                        },
                        child: const Text(
                          "Cập Nhật Thông Tin",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwitch(
      String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Switch(
            value: value,
            activeColor: const Color(0xFF19C49B),
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}
