import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/main/explore/view/listing_filter_dialog.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation_mixins/mixins.dart';

class FilterListScreen extends StatelessWidget {
  static const route = '/filter/filter-list';

  const FilterListScreen(
      {super.key, required this.title, List<String> filtersList = const []})
      : _filterList = filtersList;
  final String title;
  final List<String> _filterList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.horizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const BackButton(),
              const SizedBox(width: 4),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          Constants.verticalGutter,
          ListView.builder(
            shrinkWrap: true,
            itemCount: _filterList.length,
            itemBuilder: (context, index) => FilterListTile(
              label: _filterList[index],
              onTap: () => Navigator.of(context).pop(_filterList[index]),
            ),
          ),
        ],
      ),
    );
  }
}

typedef RangeRenderCallback = String Function(RangeValues);

class FilterSliderScreen extends StatefulWidget {
  static const route = '/filter/filter-slider';

  const FilterSliderScreen({
    super.key,
    required this.title,
    required this.min,
    required this.max,
    required this.currentValue,
    this.divisions,
    required this.rangeRender,
  });

  final String title;
  final RangeValues currentValue;
  final double max;
  final double min;
  final int? divisions;
  final RangeRenderCallback rangeRender;

  @override
  State<FilterSliderScreen> createState() => _FilterSliderScreenState();
}

class _FilterSliderScreenState extends State<FilterSliderScreen> with MIntl {
  late RangeValues currentValue = widget.currentValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.horizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const BackButton(),
              const SizedBox(width: 4),
              Text(widget.title,
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          Constants.verticalGutter,
          RangeSlider(
            values: currentValue,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            onChanged: (value) => setState(() => currentValue = value),
          ),
          Text(widget.rangeRender(currentValue)),
          Constants.verticalGutter18,
          OutlinedButton(
              onPressed: () => Navigator.of(context).pop(currentValue),
              child: const Text('Add Filter')),
        ],
      ),
    );
  }
}
