import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() =>
      _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState
    extends State<TermsAndConditionsPage> {

  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF19C49B);
    const bodyColor = Color(0xFFDFF3EC);

    return Scaffold(
      backgroundColor: mainGreen,
      body: Column(
        children: [

          /// HEADER
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Điều Kiện Và Quy Định",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),
          ),

          /// BODY
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 25, vertical: 20),
              decoration: const BoxDecoration(
                color: bodyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: Column(
                children: [

                  /// SCROLL CONTENT
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: const [

                          Text(
                            "Est Fugiat Assumenda Aut Reprehenderit",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.bold),
                          ),

                          SizedBox(height: 15),

                          Text(
                            "Lorem ipsum dolor sit amet. Et odio officia aut voluptate internos est omnis vitae ut architecto sunt non tenetur fuga ut provident vero. Quo aspernatur facere et consectetur ipsum et facere corrupti est asperiores facere. Est fugiat assumenda aut reprehenderit voluptatem sed.",
                          ),

                          SizedBox(height: 15),

                          Text(
                            "1. Ea voluptates omnis aut sequi sequi.\n"
                                "2. Est dolore quae in aliquid ducimus et autem repellendus.\n"
                                "3. Aut ipsum Quis qui porro quasi aut minus placeat!\n"
                                "4. Sit consequatur neque ab vitae facere.",
                          ),

                          SizedBox(height: 15),

                          Text(
                            "Aut quidem accusantium nam alias autem eum officiis placeat et omnis autem id officiis perspiciatis qui corrupti officia eum aliquam provident.",
                          ),

                          SizedBox(height: 15),

                          Text(
                            "Read the terms and conditions in more detail at",
                          ),

                          SizedBox(height: 5),

                          Text(
                            "www.finwiseapp.de",
                            style: TextStyle(
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// CHECKBOX
                  Row(
                    children: [
                      Checkbox(
                        value: isAccepted,
                        activeColor: mainGreen,
                        onChanged: (value) {
                          setState(() {
                            isAccepted = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                            "I accept all the terms and conditions"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isAccepted
                            ? mainGreen
                            : Colors.grey.shade400,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: isAccepted
                          ? () {
                        Navigator.pop(context);
                      }
                          : null,//k cho bam neu chua dong y
                      child: const Text(
                        "Accept",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}