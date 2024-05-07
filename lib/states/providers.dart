import 'package:buddy/states/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'user.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
  (ref) => AuthProvider(ref),
);

final userProvider = StateNotifierProvider<UserProvider, UserState>(
  (ref) => UserProvider(ref),
);
