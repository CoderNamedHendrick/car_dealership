import 'package:flutter/material.dart';
import '../../../core/common.dart';

class ListingPhoto extends StatefulWidget {
  const ListingPhoto({super.key, bool selected = false, required this.photoUrl})
      : _isSelected = selected;
  final bool _isSelected;
  final String photoUrl;

  @override
  State<ListingPhoto> createState() => _ListingPhotoState();
}

class _ListingPhotoState extends State<ListingPhoto> with AutomaticKeepAliveClientMixin {
  late AssetImage image;

  @override
  void initState() {
    super.initState();

    image = AssetImage(widget.photoUrl);
  }

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedFractionallySizedBox(
      duration: Constants.shortAnimationDur,
      widthFactor: 0.96,
      heightFactor: widget._isSelected ? 0.94 : 0.85,
      child: PhysicalModel(
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(image: image, fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
