import 'package:flutter/material.dart';

import '../domain/change_calculator.dart';
import '../domain/change_result.dart';
import 'widgets/change_breakdown.dart';

class ChangeScreen extends StatefulWidget {
  const ChangeScreen({super.key});

  @override
  State<ChangeScreen> createState() => _ChangeScreenState();
}

class _ChangeScreenState extends State<ChangeScreen> {
  final _billController = TextEditingController();
  final _owedController = TextEditingController();

  ChangeResult? _result;

  @override
  void dispose() {
    _billController.dispose();
    _owedController.dispose();
    super.dispose();
  }

  void _compute() {
    final bill = int.tryParse(_billController.text.trim()) ?? 0;
    final owed = int.tryParse(_owedController.text.trim()) ?? 0;

    FocusScope.of(context).unfocus();
    setState(() => _result = getChange(bill, owed));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vending Machine')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _billController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Bill inserted',
                prefixText: 'P ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _owedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount owed',
                prefixText: 'P ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
