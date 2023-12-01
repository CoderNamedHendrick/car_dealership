import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlideToDelete extends StatelessWidget {
  const SlideToDelete({super.key, required this.child, this.deleteOnPressed});
  final Widget child;
  final Function(BuildContext)? deleteOnPressed;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.28,
        dragDismissible: false,
        children: [
          CustomSlidableAction(
            onPressed: deleteOnPressed,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete_forever),
                const SizedBox(height: 4),
                Text('Delete',
                    style:
                        Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.surface))
              ],
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}
