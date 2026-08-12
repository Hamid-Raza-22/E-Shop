import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'components/expandable_info_section.dart';

/// "Product Details" bottom sheet content.
class ProductInfoScreen extends StatelessWidget {
  const ProductInfoScreen({super.key});

  static const List<(String, String)> _specifications = [
    ("Material", "94% Cotton, 6% Elastane"),
    ("Fit", "Regular fit, true to size"),
    ("Care", "Machine wash at 30°C, do not bleach, iron on low heat"),
    ("Origin", "Responsibly made in Portugal"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("Product Details"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              Text(
                "Sleeveless Ruffle",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: defaultPadding / 2),
              Text(
                "A cool gray cap in soft corduroy. By buying cotton products from Lindex, you're supporting more responsibly grown cotton. The fabric is soft, breathable and keeps its shape after washing.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: defaultPadding * 1.5),
              const ExpandableInfoSection(
                title: "Description",
                isInitiallyExpanded: true,
                body:
                    "Relaxed sleeveless top in a woven fabric with a ruffle trim at the neckline and armholes. Straight cut with a slightly rounded hem and a concealed zip at the back.",
              ),
              ExpandableInfoSection(
                title: "Specifications",
                children: _specifications
                    .map((entry) => _SpecificationRow(
                          label: entry.$1,
                          value: entry.$2,
                        ))
                    .toList(),
              ),
              const ExpandableInfoSection(
                title: "Materials & care",
                body:
                    "Outer fabric: 94% cotton, 6% elastane. Lining: 100% recycled polyester. Machine wash at 30°C with similar colours, do not tumble dry.",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpecificationRow extends StatelessWidget {
  const _SpecificationRow({required this.label, required this.value});

  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
