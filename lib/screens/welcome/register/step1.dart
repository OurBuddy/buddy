import 'package:beamer/beamer.dart';
import 'package:buddy/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpStep1 extends StatefulHookConsumerWidget {
  const SignUpStep1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpStep1State();
}

class _SignUpStep1State extends ConsumerState<SignUpStep1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.chevron_left_rounded, size: 32),
                  onPressed: () {
                    Beamer.of(context).beamBack();
                  },
                ),
              ),
              // First step, so select username
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Create an account',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Use your pet\'s name!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Username',
                      ),
                    ),
                    const SizedBox(height: 25),
                    Button(
                      onPressed: () {
                        Beamer.of(context)
                            .beamToNamed('/welcome/register/step2');
                      },
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
