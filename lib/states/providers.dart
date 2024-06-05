import 'package:buddy/states/auth.dart';
import 'package:buddy/states/chat.dart';
import 'package:buddy/states/full_post.dart';
import 'package:buddy/states/signup.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'user.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
  (ref) => AuthProvider(ref),
);

final userProvider = StateNotifierProvider<UserProvider, UserState>(
  (ref) => UserProvider(ref),
);

final signupProvider = StateNotifierProvider<SignupProvider, SignupState>(
  (ref) => SignupProvider(ref),
);

final chatProvider = StateNotifierProvider<ChatProvider, ChatState>(
  (ref) => ChatProvider(ref),
);

final postProvider = StateNotifierProvider<PostProvider, PostState>(
  (ref) => PostProvider(ref),
);
