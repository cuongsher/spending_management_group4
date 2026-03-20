import 'package:flutter/material.dart';

import '../ui/screens/add_budget_screen.dart';
import '../ui/screens/budget_detail_screen.dart';
import '../ui/screens/budget_list_screen.dart';
import '../ui/screens/fingerprint_screen.dart';
import '../ui/screens/forgot_password_screen.dart';
import '../ui/screens/launch_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/new_password_screen.dart';
import '../ui/screens/onboarding_screen.dart';
import '../ui/screens/password_changed_screen.dart';
import '../ui/screens/register_screen.dart';
import '../ui/screens/welcome_auth_screen.dart';

class AppRouter {
  static const String launch = '/';
  static const String onboarding = '/onboarding';
  static const String authChoice = '/auth-choice';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String newPassword = '/new-password';
  static const String passwordChanged = '/password-changed';
  static const String fingerprint = '/fingerprint';
  static const String budgetList = '/budgets';
  static const String budgetDetail = '/budgets/detail';
  static const String addBudget = '/budgets/add';

  static final Map<String, WidgetBuilder> routes = {
    launch: (_) => const LaunchScreen(),
    onboarding: (_) => const OnboardingScreen(),
    authChoice: (_) => const WelcomeAuthScreen(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    newPassword: (_) => const NewPasswordScreen(),
    passwordChanged: (_) => const PasswordChangedScreen(),
    fingerprint: (_) => const FingerprintScreen(),
    budgetList: (_) => const BudgetListScreen(),
    budgetDetail: (_) => const BudgetDetailScreen(),
    addBudget: (_) => const AddBudgetScreen(),
  };
}
