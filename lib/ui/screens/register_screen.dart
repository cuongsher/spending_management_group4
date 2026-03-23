import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2004, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;

    final day = picked.day.toString().padLeft(2, '0');
    final month = picked.month.toString().padLeft(2, '0');
    final year = picked.year.toString();
    _birthDateController.text = '$day / $month / $year';
    setState(() {});
  }

  Future<void> _handleRegister() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đăng ký thành công')));
      Navigator.pop(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(authProvider.errorMessage ?? 'Đăng ký thất bại'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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
                backgroundColor: primary,
                body: Column(
                  children: [
                    const SizedBox(height: 36),
                    const Text(
                      'Tạo Tài Khoản',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
                        decoration: const BoxDecoration(
                          color: lightBg,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(42),
                            topRight: Radius.circular(42),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              AuthTextField(
                                label: 'Tên Đầy Đủ',
                                hintText: 'Nhập họ và tên',
                                controller: _fullNameController,
                              ),
                              const SizedBox(height: 14),
                              AuthTextField(
                                label: 'Email',
                                hintText: 'example@example.com',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 14),
                              AuthTextField(
                                label: 'Số Điện Thoại',
                                hintText: '+ 123 456 789',
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 14),
                              AuthTextField(
                                label: 'Ngày Sinh',
                                hintText: 'DD / MM / YYYY',
                                controller: _birthDateController,
                                readOnly: true,
                                onTap: _pickBirthDate,
                                suffixIcon: IconButton(
                                  onPressed: _pickBirthDate,
                                  icon: const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              AuthTextField(
                                label: 'Mật Khẩu',
                                hintText: '••••••••••',
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              AuthTextField(
                                label: 'Xác Nhận Mật Khẩu',
                                hintText: '••••••••••',
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              AuthButton(
                                text: authProvider.isLoading
                                    ? 'Đang xử lý...'
                                    : 'Đăng Ký',
                                onPressed: authProvider.isLoading
                                    ? null
                                    : _handleRegister,
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Đã có tài khoản? Đăng nhập',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
