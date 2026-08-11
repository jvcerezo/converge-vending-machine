import 'package:cvm/domain/denomination.dart';
import 'package:flutter/material.dart';
import '../../domain/change_result.dart';

class ChangeBreakdown extends StatelessWidget {
  const ChangeBreakdown({super.key, required this.result});
  final ChangeResult? result;

  @override
  Widget build(BuildContext context) {
    return switch (result) {
      null => const _Placeholder(),
      ChangeFailure(:final error) => _ErrorBanner(error: error),
      ChangeSuccess(isNoChangeDue: true) => const _NoChangeDue(),
      ChangeSuccess(:final entries, :final totalPesos) => _Breakdown(
        entries: entries,
        totalPesos: totalPesos,
      ),
    };
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.point_of_sale_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'Enter a bill and an amount owed.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoChangeDue extends StatelessWidget {
  const _NoChangeDue();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'No change due.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: scheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.entries, required this.totalPesos});

  final List<ChangeEntry> entries;
  final int totalPesos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Change: P$totalPesos', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                dense: true,
                leading: Icon(
                  entry.denomination.type == DenominationType.bill
                      ? Icons.money
                      : Icons.circle_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: Text('${entry.count} x ${entry.denomination.label}'),
                trailing: Text(
                  'P${entry.centavos ~/ 100}',
                  style: theme.textTheme.bodyMedium,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
