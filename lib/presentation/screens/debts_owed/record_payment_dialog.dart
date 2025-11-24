import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/debt_model.dart';
import '../../providers/debt_provider.dart';

class RecordPaymentDialog extends StatefulWidget {
  final DebtModel debt;

  const RecordPaymentDialog({
    super.key,
    required this.debt,
  });

  @override
  State<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.debt.remainingAmount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.recordPayment),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.debt.personName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Remaining: ${AppDateUtils.formatCurrency(widget.debt.remainingAmount)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: AppStrings.paymentAmount,
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.payments),
                  prefixText: '₱',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  if (amount > widget.debt.remainingAmount) {
                    return 'Amount exceeds remaining debt';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: AppStrings.note,
                  hintText: 'Optional',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _recordPayment,
          child: const Text(AppStrings.save),
        ),
      ],
    );
  }

  Future<void> _recordPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DebtProvider>();
    final amount = double.parse(_amountController.text);
    final note = _noteController.text.trim();

    try {
      await provider.recordPayment(
        debt: widget.debt,
        amount: amount,
        note: note,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.paymentRecorded)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}