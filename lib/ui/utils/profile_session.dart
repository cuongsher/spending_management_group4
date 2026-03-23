import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/profile_provider.dart';

int? readCurrentUserId(BuildContext context) {
  final auth = context.read<AuthProvider>();
  final profile = context.read<ProfileProvider>();
  return auth.currentUserId ?? profile.user?.id;
}
