import 'package:flutter/material.dart';

import '../../router/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Color green = Color(0xFF16C8A0);
  static const Color card = Color(0xFFEAF8F0);

  final PageController _controller = PageController();
  int _index = 0;

  final List<String> _titles = const [
    'Chào Mừng Đến\nVới MoneyLoop',
    'Bạn Đã Sẵn Sàng\nLàm Giàu Chưa?',
  ];

  void _next() {
    if (_index < _titles.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      return;
    }
    Navigator.pushReplacementNamed(context, AppRouter.authChoice);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 360,
            height: 720,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Scaffold(
                backgroundColor: green,
                body: PageView.builder(
                  controller: _controller,
                  itemCount: _titles.length,
                  onPageChanged: (value) {
                    setState(() {
                      _index = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 74),
                        Text(
                          _titles[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF123E3E),
                          ),
                        ),
                        const SizedBox(height: 44),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(28, 34, 28, 28),
                            decoration: const BoxDecoration(
                              color: card,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(42),
                                topRight: Radius.circular(42),
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                Container(
                                  width: 142,
                                  height: 142,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFD8F0DE),
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: _next,
                                  borderRadius: BorderRadius.circular(16),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Tiếp',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF103E3E),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _titles.length,
                                    (dotIndex) => Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _index == dotIndex
                                            ? green
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: const Color(0xFF0F3D3D),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
