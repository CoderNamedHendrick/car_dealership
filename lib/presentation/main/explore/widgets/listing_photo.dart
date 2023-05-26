import 'package:flutter/material.dart';
import '../../../core/common.dart';

class ListingPhoto extends StatelessWidget {
  const ListingPhoto({Key? key, bool selected = false, required this.photoUrl})
      : _isSelected = selected,
        super(key: key);
  final bool _isSelected;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return AnimatedFractionallySizedBox(
      duration: Constants.shortAnimationDur,
      widthFactor: 0.96,
      heightFactor: _isSelected ? 0.94 : 0.85,
      child: PhysicalModel(
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(photoUrl), fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
          ),
        ),
      ),
    );
  }
}
