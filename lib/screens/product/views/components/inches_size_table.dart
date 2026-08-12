import 'package:flutter/material.dart';

import '../../../../constants.dart';

/// A measurement stored once, in inches, and converted on demand.
///
/// Keeping a single source of truth avoids maintaining two hardcoded tables and
/// guarantees the CM values are mathematically correct.
class SizeMeasurement {
  const SizeMeasurement(this.minInches, [this.maxInches]);

  final double minInches;
  final double? maxInches;

  static const double _cmPerInch = 2.54;

  String format({required bool inCentimeters}) {
    String value(double inches) {
      final converted = inCentimeters ? inches * _cmPerInch : inches;
      // Whole numbers stay clean ("32"), converted values keep one decimal.
      return converted == converted.roundToDouble()
          ? converted.round().toString()
          : converted.toStringAsFixed(1);
    }

    if (maxInches == null) return value(minInches);
    return "${value(minInches)}–${value(maxInches!)}";
  }
}

class SizeRow {
  const SizeRow({
    required this.label,
    required this.size,
    required this.bust,
    required this.waist,
    required this.hips,
  });

  final String label, size;
  final SizeMeasurement bust, waist, hips;
}

/// Size chart values as shown in the Size Guide design (inches).
const List<SizeRow> sizeGuideRows = [
  SizeRow(
    label: "XS",
    size: "0",
    bust: SizeMeasurement(32),
    waist: SizeMeasurement(24, 25),
    hips: SizeMeasurement(34, 35),
  ),
  SizeRow(
    label: "S",
    size: "2–4",
    bust: SizeMeasurement(34),
    waist: SizeMeasurement(26, 27),
    hips: SizeMeasurement(36, 39),
  ),
  SizeRow(
    label: "M",
    size: "6–8",
    bust: SizeMeasurement(36),
    waist: SizeMeasurement(28, 29),
    hips: SizeMeasurement(38, 39),
  ),
  SizeRow(
    label: "L",
    size: "10–12",
    bust: SizeMeasurement(38, 40),
    waist: SizeMeasurement(31, 33),
    hips: SizeMeasurement(41, 43),
  ),
  SizeRow(
    label: "XL",
    size: "14",
    bust: SizeMeasurement(42),
    waist: SizeMeasurement(34),
    hips: SizeMeasurement(44),
  ),
];

/// Size chart table. Set [inCentimeters] to convert every measurement.
class SizeTable extends StatelessWidget {
  const SizeTable({super.key, this.inCentimeters = false});

  final bool inCentimeters;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      // Horizontal scroll prevents overflow on narrow screens once the CM
      // values (which are wider) are shown.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder(
            verticalInside: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black12
                    : Colors.white10),
          ),
          columns: const <DataColumn>[
            DataColumn(label: Text('')),
            DataColumn(label: Text('Size')),
            DataColumn(label: Text('Bust')),
            DataColumn(label: Text('Waist')),
            DataColumn(label: Text('Hips')),
          ],
          rows: sizeGuideRows
              .map(
                (row) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(row.label)),
                    DataCell(Text(row.size)),
                    DataCell(
                        Text(row.bust.format(inCentimeters: inCentimeters))),
                    DataCell(
                        Text(row.waist.format(inCentimeters: inCentimeters))),
                    DataCell(
                        Text(row.hips.format(inCentimeters: inCentimeters))),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

/// Kept for backwards compatibility with the original component name.
class InchesSizeTable extends StatelessWidget {
  const InchesSizeTable({super.key});

  @override
  Widget build(BuildContext context) => const SizeTable();
}
