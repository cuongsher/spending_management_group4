import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {

  final TextEditingController passwordController = TextEditingController();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF19C49B);
    const bodyColor = Color(0xFFDFF3EC);

    return Scaffold(
      backgroundColor: mainGreen,
      body: Column(
        children: [

          /// ===== HEADER =====
          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Xóa Tài Khoản",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// ===== BODY =====
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: bodyColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(45),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    const SizedBox(height: 10),

                    const Text(
                      "Are You Sure You Want To Delete Your Account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "This action will permanently delete all of your data, and you will not be able to recover it. Please keep the following in mind before proceeding:",
                          ),
                          SizedBox(height: 15),
                          Text("• All your expenses, income and associated transactions will be eliminated."),
                          SizedBox(height: 8),
                          Text("• You will not be able to access your account or any related information."),
                          SizedBox(height: 8),
                          Text("• This action cannot be undone."),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Please Enter Your Password To Confirm Deletion Of Your Account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 20),

                    /// PASSWORD FIELD
                    TextField(
                      controller: passwordController,
                      obscureText: obscure,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// DELETE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          showDeleteDialog();
                        },
                        child: const Text(
                          "Vâng, Xóa Tài Khoản",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// CANCEL
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Hủy",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  "Delete Account",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                const Text(
                  "By deleting your account, you agree that you understand the consequences of this action and that you agree to permanently delete your account and all associated data.",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF19C49B),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // close dialog
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      "Yes, Delete Account",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.green.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pop(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}