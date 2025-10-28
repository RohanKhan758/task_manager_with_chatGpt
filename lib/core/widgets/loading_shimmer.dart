import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Simple shimmer placeholder. Wrap any child to display loading effect.
class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: child,
    );
  }
}
