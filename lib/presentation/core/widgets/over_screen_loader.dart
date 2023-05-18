import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OverScreenLoader extends StatelessWidget {
  const OverScreenLoader({Key? key, this.loading = false, required this.child}) : super(key: key);
  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loading,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          if (loading)
            const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black12),
              child: Center(
                child: Card(child: Padding(padding: EdgeInsets.all(Constants.horizontalMargin), child: CarLoader())),
              ),
            ),
        ],
      ),
    );
  }
}
