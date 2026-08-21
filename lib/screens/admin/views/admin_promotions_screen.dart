import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/admin/admin_promotions_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/promotion_model.dart';
import '../../../utils/formatters.dart';

/// Promo-code management: create, edit, activate and delete campaigns.
class AdminPromotionsScreen extends StatelessWidget {
  const AdminPromotionsScreen({super.key});

  Future<void> _openForm(BuildContext context, {PromotionModel? promotion}) {
    return showDialog<void>(
      context: context,
      builder: (context) => _PromotionDialog(promotion: promotion),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminPromotionsController.to;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: Text(translations.adminPromoCreate),
      ),
      body: Obx(() {
        final promotions = controller.promotions;

        if (promotions.isEmpty) {
          return Center(child: Text(translations.adminPromoNone));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            defaultPadding,
            defaultPadding,
            defaultPadding,
            defaultPadding * 5,
          ),
          itemCount: promotions.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: defaultPadding / 2),
          itemBuilder: (context, index) => _PromotionTile(
            promotion: promotions[index],
            onEdit: () => _openForm(context, promotion: promotions[index]),
          ),
        );
      }),
    );
  }
}

class _PromotionTile extends StatelessWidget {
  const _PromotionTile({required this.promotion, required this.onEdit});

  final PromotionModel promotion;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminPromotionsController.to;
    final isLive = promotion.isCurrentlyValid;

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding / 2,
              vertical: defaultPadding / 4,
            ),
            decoration: BoxDecoration(
              color: (isLive ? successColor : Colors.grey).withValues(alpha: 0.12),
              borderRadius: const BorderRadius.all(
                Radius.circular(defaultBorderRadious),
              ),
            ),
            child: Text(
              "-${promotion.percentOff}%",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isLive ? successColor : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promotion.code,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  promotion.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "${formatDate(promotion.validFrom)} — "
                  "${formatDate(promotion.validTo)}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (promotion.usageLimit != null)
                  Text(
                    "${translations.adminPromoUsageLimit}: "
                    "${promotion.usedCount}/${promotion.usageLimit}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isLive
                    ? translations.adminPromoActive
                    : translations.adminPromoInactive,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isLive ? successColor : Colors.grey,
                ),
              ),
              Switch(
                value: promotion.isActive,
                onChanged: (_) => controller.toggleActive(promotion),
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "edit") {
                onEdit();
                return;
              }
              final id = promotion.id;
              if (id != null) controller.delete(id);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "edit", child: Text(translations.actionEdit)),
              PopupMenuItem(
                value: "delete",
                child: Text(
                  translations.actionDelete,
                  style: const TextStyle(color: errorColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PromotionDialog extends StatefulWidget {
  const _PromotionDialog({this.promotion});

  final PromotionModel? promotion;

  @override
  State<_PromotionDialog> createState() => _PromotionDialogState();
}

class _PromotionDialogState extends State<_PromotionDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _code = TextEditingController(text: widget.promotion?.code);
  late final _title = TextEditingController(text: widget.promotion?.title);
  late final _percent = TextEditingController(
    text: widget.promotion?.percentOff.toString(),
  );
  late final _usageLimit = TextEditingController(
    text: widget.promotion?.usageLimit?.toString(),
  );

  late DateTime _validFrom = widget.promotion?.validFrom ?? DateTime.now();
  late DateTime _validTo = widget.promotion?.validTo ??
      DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _code.dispose();
    _title.dispose();
    _percent.dispose();
    _usageLimit.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _validFrom : _validTo;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked == null) return;

    setState(() {
      if (isStart) {
        _validFrom = picked;
        // Keep the window valid when the start is pushed past the end.
        if (_validTo.isBefore(picked)) _validTo = picked;
      } else {
        _validTo = picked;
      }
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final promotion = PromotionModel(
      id: widget.promotion?.id,
      code: _code.text.trim(),
      title: _title.text.trim(),
      percentOff: int.parse(_percent.text.trim()),
      validFrom: _validFrom,
      validTo: _validTo,
      usageLimit: int.tryParse(_usageLimit.text.trim()),
      usedCount: widget.promotion?.usedCount ?? 0,
      isActive: widget.promotion?.isActive ?? true,
    );

    final saved = await AdminPromotionsController.to.save(promotion);
    if (!mounted) return;

    if (saved) {
      Navigator.pop(context);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AdminPromotionsController.to.error ??
              AppLocalizations.of(context).errorGeneric,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        widget.promotion == null
            ? translations.adminPromoCreate
            : translations.actionEdit,
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _code,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z0-9]")),
                  ],
                  validator: (value) => (value?.trim() ?? "").isEmpty
                      ? translations.validationRequired
                      : null,
                  decoration: InputDecoration(
                    labelText: translations.adminPromoCode,
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                TextFormField(
                  controller: _title,
                  validator: (value) => (value?.trim() ?? "").isEmpty
                      ? translations.validationRequired
                      : null,
                  decoration: InputDecoration(
                    labelText: translations.adminFieldTitle,
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                TextFormField(
                  controller: _percent,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    final percent = int.tryParse(value?.trim() ?? "");
                    if (percent == null) return translations.validationRequired;
                    if (percent < 1 || percent > 90) return "1–90 only";
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: translations.adminPromoPercentOff,
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                TextFormField(
                  controller: _usageLimit,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: translations.adminPromoUsageLimit,
                    helperText: "Leave empty for unlimited",
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: translations.adminPromoValidFrom,
                        value: _validFrom,
                        onTap: () => _pickDate(isStart: true),
                      ),
                    ),
                    const SizedBox(width: defaultPadding / 2),
                    Expanded(
                      child: _DateField(
                        label: translations.adminPromoValidTo,
                        value: _validTo,
                        onTap: () => _pickDate(isStart: false),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(translations.actionCancel),
        ),
        Obx(
          () => FilledButton(
            onPressed:
                AdminPromotionsController.to.isSaving ? null : _save,
            child: Text(translations.actionSave),
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(formatDate(value)),
      ),
    );
  }
}
