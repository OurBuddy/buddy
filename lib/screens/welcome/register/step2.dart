import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:buddy/components/buttons.dart';
import 'package:buddy/components/loading.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpStep2 extends StatefulHookConsumerWidget {
  const SignUpStep2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpStep2State();
}

class _SignUpStep2State extends ConsumerState<SignUpStep2> {
  Future<bool> isUserAvailable = Future.value(false);

  @override
  Widget build(BuildContext context) {
    final signup = ref.watch(signupProvider);
    final signupNotif = ref.watch(signupProvider.notifier);

    final email = useTextEditingController(text: signup.email);
    final password = useTextEditingController(text: signup.password);
    final confirmPassword = useTextEditingController();

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
                        'Let\'s get purrsonal',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'We need your login details to create an account.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'email',
                        ),
                        controller: email,
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'password',
                        ),
                        obscureText: true,
                        controller: password,
                        autofillHints: const [AutofillHints.password],
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'confirm password',
                        ),
                        obscureText: true,
                        controller: confirmPassword,
                        autofillHints: const [AutofillHints.password],
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 25),
                      Button(
                        onPressed: () {},
                        child: const Text('Next'),
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
