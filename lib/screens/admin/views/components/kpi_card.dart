import 'package:flutter/material.dart';

import '../../../../constants.dart';

/// Single metric tile used on the overview grid.
class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = primaryColor,
    this.caption,
    this.onTap,
  });

  final String label, value;
  final IconData icon;
  final Color color;
  final String? caption;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(defaultBorderRadious)),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(defaultPadding / 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(defaultBorderRadious),
                      ),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: defaultPadding / 2),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (caption != null) ...[
                const SizedBox(height: defaultPadding / 4),
                Text(
                  caption!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
