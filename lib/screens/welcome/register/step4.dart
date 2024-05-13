import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:buddy/components/buttons.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpStep4 extends StatefulHookConsumerWidget {
  const SignUpStep4({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpStep4State();
}

class _SignUpStep4State extends ConsumerState<SignUpStep4> {
  Future<bool> isUserAvailable = Future.value(false);

  @override
  Widget build(BuildContext context) {
    final signup = ref.watch(signupProvider);
    final signupNotif = ref.watch(signupProvider.notifier);

    final person = useTextEditingController(text: signup.personName);
    final pet = useTextEditingController(text: signup.petName);

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Nearly there! You\'ll be set up in no time.',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      signup.hasPet ?? false
                          ? 'Awwww, we\'re so excited to have you and your buddy on board!'
                          : 'Awwww, we\'re so excited to have you on board!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'your name',
                      ),
                      controller: person,
                    ),
                    if (signup.hasPet ?? false) ...[
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'your buddy\'s name',
                        ),
                        controller: pet,
                      ),
                    ],
                    const SizedBox(height: 25),
                    Button(
                      onPressed: () {
                        //check
                        if (person.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter your name'),
                            ),
                          );
                          return;
                        }
                        if ((signup.hasPet ?? false) && pet.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter your buddy\'s name'),
                            ),
                          );
                          return;
                        }

                        signupNotif.setPersonName(person.text);
                        signupNotif.setPetName(pet.text);

                        Beamer.of(context)
                            .beamToNamed('/welcome/register/step5');
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
