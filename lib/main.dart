import 'package:buddy/router.dart';
import 'package:flutter/material.dart';
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

  runApp(const ProviderScope(child: Buddy()));
}

class Buddy extends StatelessWidget {
  const Buddy({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Buddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
