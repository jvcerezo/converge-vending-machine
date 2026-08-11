import 'package:flutter/material.dart';

import '../domain/change_calculator.dart';
import '../domain/change_result.dart';
import '../domain/denomination.dart';
import 'theme/peso_theme.dart';
import 'widgets/amount_field.dart';
import 'widgets/bill_picker.dart';
import 'widgets/change_breakdown.dart';

class ChangeScreen extends StatefulWidget {
  const ChangeScreen({super.key});

  @override
  State<ChangeScreen> createState() => _ChangeScreenState();
}

class _ChangeScreenState extends State<ChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _billController = TextEditingController();
  final _owedController = TextEditingController();

  ChangeResult? _result;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _billController.addListener(_refreshSubmitState);
    _owedController.addListener(_refreshSubmitState);
  }

  @override
  void dispose() {
    _billController.dispose();
    _owedController.dispose();
    super.dispose();
  }

  void _refreshSubmitState() {
    final canSubmit =
        int.tryParse(_billController.text.trim()) != null &&
        int.tryParse(_owedController.text.trim()) != null;
    if (canSubmit != _canSubmit) setState(() => _canSubmit = canSubmit);
  }

  String? _validateBill(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter the bill you inserted.';

    final bill = int.tryParse(text);
    if (bill == null) return 'Digits only.';
    if (bill == 0) return 'Insert a banknote, or leave both at 0';
    if (!DenominationValue.isAcceptedBill(bill)) {
      return 'Not a banknote. Try P20, P50, P100, P200, P500, or P1000';
    }
    return null;
  }

  String? _validatedOwed(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter the amount owed.';

    final owed = int.tryParse(text);
    if (owed == null) return 'Digits only.';
    if (owed > maxOwed) return 'Maximum supported amount is P$maxOwed';
    return null;
  }

  // tapping a note just fills the bill field, validation stays the same
  void _selectBill(DenominationValue bill) {
    _billController.text = bill.pesos.toString();
  }

  void _compute() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _result = null);
      return;
    }

    final bill = int.parse(_billController.text.trim());
    final owed = int.parse(_owedController.text.trim());
    setState(() => _result = getChange(bill, owed));
  }

  void _reset() {
    _billController.clear();
    _owedController.clear();
    _formKey.currentState?.reset();
    FocusScope.of(context).unfocus();
    setState(() => _result = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Converge Vending Machine'),
        actions: [
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          // thin brass line under the app bar
          child: ColoredBox(
            color: PesoColors.brandBrass,
            child: SizedBox(height: 3, width: double.infinity),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          // scrollable so the keyboard does not squish the fields
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            children: [
              const _SectionLabel('Insert a bill'),
              const SizedBox(height: 8),
              // keeps the picker in sync with whatever is typed in the field
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _billController,
                builder: (context, value, _) => BillPicker(
                  selectedPesos: int.tryParse(value.text.trim()),
                  onSelected: _selectBill,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AmountField(
                      controller: _billController,
                      label: 'Bill inserted',
                      helperText: 'Tap a note above, or type the amount',
                      validator: _validateBill,
                    ),
                    const SizedBox(height: 12),
                    AmountField(
                      controller: _owedController,
                      label: 'Amount owed',
                      helperText: 'P0 to P$maxOwed',
                      textInputAction: TextInputAction.done,
                      // when user submits call function to compute
                      onSubmitted: _compute,
                      // call function to validate user input
                      validator: _validatedOwed,
                    ),
                  ],
                ),
              ),
              // button user can press when ready to submit
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _canSubmit ? _compute : null,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calculate_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Compute change'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const _SectionLabel('Your change'),
              const SizedBox(height: 8),
              ChangeBreakdown(result: _result),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
