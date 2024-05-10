import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.onPressed,
      required this.child,
      this.isLoading = false});

  final void Function() onPressed;
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Hero(
        tag: 'button',
        child: SizedBox(
          width: 48,
          height: 48,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      );
    }

    return Hero(
      tag: 'button',
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onPressed,
            child: child,
          ),
        ),
      ),
    );
  }
}

class TonalButton extends StatelessWidget {
  const TonalButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.isLoading = false});

  final void Function() onPressed;
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Hero(
        tag: 'button',
        child: SizedBox(
          width: 48,
          height: 48,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: CircularProgressIndicator(
              color: Theme.of(context).canvasColor,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton(
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
