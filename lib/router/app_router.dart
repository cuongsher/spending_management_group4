import 'package:flutter/material.dart';

import '../ui/screens/add_budget_screen.dart';
import '../ui/screens/add_recurring_transaction_screen.dart';
import '../ui/screens/add_transaction_screen.dart';
import '../ui/screens/asset_detail_screen.dart';
import '../ui/screens/asset_list_screen.dart';
import '../ui/screens/budget_detail_screen.dart';
import '../ui/screens/budget_list_screen.dart';
import '../ui/screens/category_management_screen.dart';
import '../ui/screens/customize_screen.dart';
import '../ui/screens/delete_account_screen.dart';
import '../ui/screens/edit_profile_screen.dart';
import '../ui/screens/fingerprint_screen.dart';
import '../ui/screens/forgot_password_screen.dart';
import '../ui/screens/history_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/launch_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/new_password_screen.dart';
import '../ui/screens/notification_screen.dart';
import '../ui/screens/notification_settings_screen.dart';
import '../ui/screens/onboarding_screen.dart';
import '../ui/screens/password_changed_screen.dart';
import '../ui/screens/password_settings_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/recurring_transactions_screen.dart';
import '../ui/screens/register_screen.dart';
import '../ui/screens/report_screen.dart';
import '../ui/screens/security_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/shopping_list_screen.dart';
import '../ui/screens/terms_screen.dart';
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
  static const String home = '/home';
  static const String report = '/report';
  static const String history = '/history';
  static const String customize = '/customize';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String security = '/profile/security';
  static const String settings = '/profile/settings';
  static const String notificationSettings = '/profile/settings/notifications';
  static const String passwordSettings = '/profile/settings/password';
  static const String deleteAccount = '/profile/settings/delete-account';
  static const String terms = '/profile/security/terms';
  static const String categoryManagement = '/customize/categories';
  static const String shoppingList = '/customize/shopping-list';
  static const String assetList = '/customize/assets';
  static const String assetDetail = '/customize/assets/detail';
  static const String recurringTransactions = '/customize/recurring';
  static const String addRecurringTransaction = '/customize/recurring/add';
  static const String addTransaction = '/transactions/add';
  static const String notifications = '/notifications';
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
    home: (_) => const HomeScreen(),
    report: (_) => const ReportScreen(),
    history: (_) => const HistoryScreen(),
    customize: (_) => const CustomizeScreen(),
    profile: (_) => const ProfileScreen(),
    editProfile: (_) => const EditProfileScreen(),
    security: (_) => const SecurityScreen(),
    settings: (_) => const SettingsScreen(),
    notificationSettings: (_) => const NotificationSettingsScreen(),
    passwordSettings: (_) => const PasswordSettingsScreen(),
    deleteAccount: (_) => const DeleteAccountScreen(),
    terms: (_) => const TermsScreen(),
    categoryManagement: (_) => const CategoryManagementScreen(),
    shoppingList: (_) => const ShoppingListScreen(),
    assetList: (_) => const AssetListScreen(),
    assetDetail: (_) => const AssetDetailScreen(),
    recurringTransactions: (_) => const RecurringTransactionsScreen(),
    addRecurringTransaction: (_) => const AddRecurringTransactionScreen(),
    addTransaction: (_) => const AddTransactionScreen(),
    notifications: (_) => const NotificationScreen(),
    budgetList: (_) => const BudgetListScreen(),
    budgetDetail: (_) => const BudgetDetailScreen(),
    addBudget: (_) => const AddBudgetScreen(),
  };
}
