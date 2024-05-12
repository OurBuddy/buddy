import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:buddy/components/buttons.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpStep3 extends StatefulHookConsumerWidget {
  const SignUpStep3({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpStep3State();
}

class _SignUpStep3State extends ConsumerState<SignUpStep3> {
  Future<bool> isUserAvailable = Future.value(false);

  @override
  Widget build(BuildContext context) {
    final signupNotif = ref.watch(signupProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, size: 32),
                  onPressed: () {
                    Beamer.of(context).beamBack();
                  },
                ),
              ),
              // First step, so select username
              Expanded(
                child: AutofillGroup(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Do you have a pet?',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'We need to know if you have a pet to set up your account.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      Button(
                        onPressed: () {
                          signupNotif.setHasPet(true);
                          Beamer.of(context)
                              .beamToNamed('/welcome/register/step4');
                        },
                        child: const Text('Yes! I have a pet'),
                      ),
                      const SizedBox(height: 10),
                      TonalButton(
                        onPressed: () {
                          signupNotif.setHasPet(false);
                          Beamer.of(context)
                              .beamToNamed('/welcome/register/step4');
                        },
                        child: const Text('No, I\'m just a friendly hooman!'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
