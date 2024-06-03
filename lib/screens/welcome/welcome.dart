import 'package:beamer/beamer.dart';
import 'package:buddy/components/buttons.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Image.asset("assets/logo-with-shadow.png")),
                Button(
                  onPressed: () {
                    Beamer.of(context).beamToNamed("/welcome/login");
                  },
                  child: const Text("Log In"),
                ),
                const SizedBox(height: 16),
                TonalButton(
                  onPressed: () {
                    Beamer.of(context).beamToNamed("/welcome/register");
                  },
                  child: const Text("Register"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
