import 'package:flutter/material.dart';

import '../../domain/denomination.dart';
import 'money_swatch.dart';

// shortcut for the accepted bills. typing in the field still works.
class BillPicker extends StatelessWidget {
  const BillPicker({
    super.key,
    required this.selectedPesos,
    required this.onSelected,
  });

  // whatever is in the bill field right now, null if empty or not a number
  final int? selectedPesos;
  final ValueChanged<DenominationValue> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final bill in DenominationValue.acceptedBills.reversed)
          _BillButton(
            bill: bill,
            selected: bill.pesos == selectedPesos,
            onTap: () => onSelected(bill),
          ),
      ],
    );
  }
}

class _BillButton extends StatelessWidget {
  const _BillButton({
    required this.bill,
    required this.selected,
    required this.onTap,
  });

  final DenominationValue bill;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected ? scheme.primary.withValues(alpha: 0.08) : null,
          border: Border.all(
            color: selected ? scheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MoneySwatch(denomination: bill, width: 72),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  Icon(Icons.check_circle, size: 12, color: scheme.primary),
                  const SizedBox(width: 3),
                ],
                Text(
                  selected ? 'Inserted' : 'Insert',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected ? scheme.primary : scheme.outline,
                    fontWeight: selected ? FontWeight.w700 : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
