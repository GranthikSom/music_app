import 'package:flutter/material.dart';

class SongBox extends StatelessWidget {
  final Widget? child;

  const SongBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 10,
            offset: const Offset(1, 1),
          ),
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 10,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}
