import 'package:beamer/beamer.dart';
import 'package:buddy/screens/welcome/login.dart';
import 'package:buddy/screens/welcome/welcome.dart';
import 'package:buddy/states/providers.dart';
import 'package:buddy/states/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://smhxqbuxkxonfrlojcib.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI"
        "6InNtaHhxYnV4a3hvbmZybG9qY2liIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUwNTg"
        "2NTcsImV4cCI6MjAzMDYzNDY1N30.iXlpyyq3UB9GAiDZeltOjvsU-vqmlcrVkzAUJut"
        "m54k",
  );

  await Hive.initFlutter();
  await Hive.openBox(UserProvider.boxName);

  runApp(const ProviderScope(child: Buddy()));
}

class Buddy extends HookConsumerWidget {
  const Buddy({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(authProvider);

    final router = BeamerDelegate(
        initialPath: '/welcome',
        locationBuilder: RoutesLocationBuilder(
          routes: {
            // Return either Widgets or BeamPages if more customization is needed
            '/welcome': (context, state, data) => const WelcomeScreen(),
            '/welcome/login': (context, state, data) => const LoginScreen(),
          },
        ).call,
        guards: [
          BeamGuard(
            pathPatterns: ['/welcome', '/welcome/login'],
            guardNonMatching: true,
            check: (context, location) => ref.read(authProvider).isSignedIn,
            beamToNamed: (origin, target) => '/welcome',
          ),
        ]);

    return MaterialApp.router(
      title: 'Buddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          // pill with black border
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          // pill with black border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          insetPadding: const EdgeInsets.all(18),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          backgroundColor: Colors.black,
          contentTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      routeInformationParser: BeamerParser(),
      routerDelegate: router,
    );
  }
}
