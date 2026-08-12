import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'components/inches_size_table.dart';

class SizeGuideScreen extends StatefulWidget {
  const SizeGuideScreen({super.key});

  @override
  State<SizeGuideScreen> createState() => _SizeGuideScreenState();
}

class _SizeGuideScreenState extends State<SizeGuideScreen> {
  bool _isShowCentimetersSize = false;

  /// Measurement instructions from the design.
  static const List<(String, String)> _measurementGuide = [
    (
      "Bust",
      "Measure under your arms at the fullest part of your bust. Be sure to go over your shoulder blades."
    ),
    (
      "Natural Waist",
      "Measure around the narrowest part of your waistline with one forefinger between your body and the measuring tape."
    ),
    (
      "Hips",
      "Stand with your heels together and measure around the fullest part of your hips."
    ),
  ];

  void updateSizes(bool isShowCentimeters) {
    if (_isShowCentimetersSize == isShowCentimeters) return;
    setState(() => _isShowCentimetersSize = isShowCentimeters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Size guide")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            Row(
              children: [
                Expanded(
                  child: _UnitButton(
                    label: "Centimeters",
                    isActive: _isShowCentimetersSize,
                    press: () => updateSizes(true),
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Expanded(
                  child: _UnitButton(
                    label: "Inches",
                    isActive: !_isShowCentimetersSize,
                    press: () => updateSizes(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding * 1.5),
            SizeTable(inCentimeters: _isShowCentimetersSize),
            const SizedBox(height: defaultPadding * 2),
            Text(
              "Measurement Guide",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: defaultPadding * 1.5),
            ..._measurementGuide.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.$1,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    Text(
                      entry.$2,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Segmented unit selector (Centimeters / Inches).
class _UnitButton extends StatelessWidget {
  const _UnitButton({
    required this.label,
    required this.isActive,
    required this.press,
  });

  final String label;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return ElevatedButton(
        onPressed: press,
        child: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: press,
      child: Text(label),
    );
  }
}
