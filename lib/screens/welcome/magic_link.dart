import 'package:beamer/beamer.dart';
import 'package:buddy/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MagicLinkScreen extends HookConsumerWidget {
  const MagicLinkScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      size: 32,
                    ),
                    onPressed: () {
                      Beamer.of(context).beamBack();
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/dog-looking-into-screen.png',
                        height: 200,
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'Check your email',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'We have sent you a magic link to your email.'
                        '\n Click on the link to log in.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      Button(
                        onPressed: () {
                          Beamer.of(context).beamToNamed('/welcome');
                        },
                        child: const Text('Back to home'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
