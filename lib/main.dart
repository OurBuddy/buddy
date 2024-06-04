import 'package:beamer/beamer.dart';
import 'package:buddy/screens/home/chats.dart';
import 'package:buddy/screens/home/feed.dart';
import 'package:buddy/screens/home/profile.dart';
import 'package:buddy/screens/welcome/login.dart';
import 'package:buddy/screens/welcome/magic_link.dart';
import 'package:buddy/screens/welcome/register/create.dart';
import 'package:buddy/screens/welcome/register/step1.dart';
import 'package:buddy/screens/welcome/register/step2.dart';
import 'package:buddy/screens/welcome/register/step3.dart';
import 'package:buddy/screens/welcome/register/step4.dart';
import 'package:buddy/screens/welcome/register/step5.dart';
import 'package:buddy/screens/welcome/welcome.dart';
import 'package:buddy/states/providers.dart';
import 'package:buddy/states/user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://smhxqbuxkxonfrlojcib.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6"
        "InNtaHhxYnV4a3hvbmZybG9qY2liIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUwNTg2N"
        "TcsImV4cCI6MjAzMDYzNDY1N30.iXlpyyq3UB9GAiDZeltOjvsU-vqmlcrVkzAUJutm54k",
  );

  await Hive.initFlutter();
  await Hive.openBox(UserProvider.boxName);

  runApp(const ProviderScope(child: Buddy()));
}

class Buddy extends StatefulHookConsumerWidget {
  const Buddy({super.key});

  // This widget is the root of your application.
  @override
  ConsumerState<Buddy> createState() => _BuddyState();
}

class _BuddyState extends ConsumerState<Buddy> {
  late final BeamerDelegate delegate;

  @override
  void initState() {
    super.initState();

    delegate = router(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          background: const Color(0xFFF4F4F4),
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
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
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.black,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 100,
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
        cardTheme: CardTheme(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          elevation: 10,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        useMaterial3: true,
        visualDensity: VisualDensity.comfortable,
      ),
      themeMode: ThemeMode.light,
      routeInformationParser: BeamerParser(),
      routerDelegate: delegate,
    );
  }

  BeamerDelegate router(BuildContext context, WidgetRef ref) {
    return BeamerDelegate(
      initialPath: '/',
      locationBuilder: RoutesLocationBuilder(
        routes: {
          // Return either Widgets or BeamPages if more customization is needed
          '/welcome': (context, state, data) => const WelcomeScreen(),
          '/welcome/login': (context, state, data) => const LoginScreen(),
          '/welcome/magicLink': (context, state, data) =>
              const MagicLinkScreen(),
          '/welcome/register': (context, state, data) => const SignUpStep1(),
          '/welcome/register/step2': (context, state, data) =>
              const SignUpStep2(),
          '/welcome/register/step3': (context, state, data) =>
              const SignUpStep3(),
          '/welcome/register/step4': (context, state, data) =>
              const SignUpStep4(),
          '/welcome/register/step5': (context, state, data) =>
              const SignUpStep5(),
          '/welcome/register/create': (context, state, data) =>
              const CreateScreen(),

          '/feed': (context, state, data) => const FeedScreen(),
          '/chat': (context, state, data) => const ChatsScreen(),
          '/profile': (context, state, data) => const ProfileScreen(),
          '/profile/:id': (context, state, data) => const ProfileScreen(),

          // Redirect / to /feed
        },
      ).call,
      guards: [
        BeamGuard(
          pathPatterns: ['/welcome', '/welcome/*'],
          guardNonMatching: true,
          check: (context, location) => ref.watch(authProvider).isSignedIn,
          beamToNamed: (origin, target) => '/welcome',
        ),
        BeamGuard(
          pathPatterns: ['/'],
          check: (context, location) => false,
          beamToNamed: (origin, target) => '/feed',
        ),
      ],
    );
  }
}
