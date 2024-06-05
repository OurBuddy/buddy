import 'package:beamer/beamer.dart';
import 'package:buddy/components/buttons.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends StatefulHookConsumerWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();

    final auth = ref.watch(authProvider);
    final authNotif = ref.watch(authProvider.notifier);

    Future.delayed(Duration.zero, () {
      if (auth.isMagicLinkSent) {
        authNotif.setInitial();
        Beamer.of(context).beamToNamed('/welcome/magicLink');
      }
      if (auth.isSignedIn) Beamer.of(context).beamToNamed('/feed');
    });

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
                  child: AutofillGroup(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Log in',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 25),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'email',
                          ),
                          controller: emailController,
                          autofillHints: const [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'password',
                          ),
                          obscureText: true,
                          controller: passwordController,
                          autofillHints: const [AutofillHints.password],
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(height: 16),
                        if (auth.error != null)
                          Text(
                            "There was an issue logging in: ${auth.error}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 16),
                        TextButton(
                            onPressed: () {
                              // Email magic link
                              final email = emailController.text;
                              if (email.isNotEmpty) {
                                ref
                                    .read(authProvider.notifier)
                                    .sendMagicLink(email);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter your email'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Forgot password?')),
                      ],
                    ),
                  ),
                ),
                TonalButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    if (email.isNotEmpty && password.isNotEmpty) {
                      authNotif.logInWithPassword(email, password);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email and password'),
                        ),
                      );
                    }
                  },
                  isLoading: auth.isLoading,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
