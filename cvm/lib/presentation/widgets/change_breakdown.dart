import 'package:flutter/material.dart';

import '../../domain/change_result.dart';
import '../theme/peso_theme.dart';
import 'money_swatch.dart';

class ChangeBreakdown extends StatelessWidget {
  const ChangeBreakdown({super.key, required this.result});
  final ChangeResult? result;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      child: switch (result) {
        null => const _Placeholder(),
        ChangeFailure(:final error) => _ErrorBanner(error: error),
        ChangeSuccess(isNoChangeDue: true) => const _NoChangeDue(),
        ChangeSuccess(:final entries, :final totalPesos) => _Breakdown(
          key: ValueKey(totalPesos),
          entries: entries,
          totalPesos: totalPesos,
        ),
      },
    );
  }
}

// shared card for the empty and no change states. the result area is inside
// a scroll view now so it needs a min height or it collapses
class _StateCard extends StatelessWidget {
  const _StateCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return _StateCard(
      children: [
        Icon(Icons.point_of_sale_outlined, size: 48, color: scheme.outline),
        const SizedBox(height: 12),
        Text(
          'Enter a bill and an amount owed.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.outline),
        ),
      ],
    );
  }
}

class _NoChangeDue extends StatelessWidget {
  const _NoChangeDue();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return _StateCard(
      children: [
        Icon(Icons.check_circle_outline, size: 48, color: scheme.primary),
        const SizedBox(height: 12),
        Text(
          'No change due.',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.error});

  final ChangeError error;

  String get _message => switch (error) {
    ChangeError.insufficientPayment => 'Insufficient payment.',
    ChangeError.owedOutOfRange =>
      'Amount owed must be between 0 and 1000 pesos.',
    ChangeError.invalidBill => 'Invalid bill denomination.',
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: scheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({
    super.key,
    required this.entries,
    required this.totalPesos,
  });

  final List<ChangeEntry> entries;
  final int totalPesos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(
            color: PesoColors.brandDeep,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Text(
            'Change: P$totalPesos',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              for (final entry in entries)
                _EntryTile(key: ValueKey(entry.denomination), entry: entry),
            ],
          ),
        ),
      ],
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({super.key, required this.entry});

  final ChangeEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: SizedBox(
        width: 56,
        child: Align(
          alignment: Alignment.centerLeft,
          child: MoneySwatch(denomination: entry.denomination, width: 56),
        ),
      ),
      title: Text(
        '${entry.count} x ${entry.denomination.label}',
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: Text(
        'P${entry.centavos ~/ 100}',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
