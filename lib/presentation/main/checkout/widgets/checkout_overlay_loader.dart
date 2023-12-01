import 'package:flutter/material.dart';

class CheckoutOverlayLoader extends StatelessWidget {
  const CheckoutOverlayLoader({super.key, this.loading = false, required this.child});
  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loading,
      child: Stack(
        children: [
          child,
          if (loading)
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.black12),
                child: Center(
                  child: PhysicalModel(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
