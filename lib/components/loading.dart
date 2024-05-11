import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key, this.padding = const EdgeInsets.all(5)});

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: padding,
      child: CircularProgressIndicator(
        color: Theme.of(context).canvasColor,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
