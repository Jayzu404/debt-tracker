import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/debt_model.dart';
import '../../providers/debt_provider.dart';

class AddDebtDialog extends StatefulWidget {
  final bool isIOwe;
  final DebtModel? debt;

  const AddDebtDialog({
    super.key,
    required this.isIOwe,
    this.debt,
  });

  @override
  State<AddDebtDialog> createState() => _AddDebtDialogState();
}

class _AddDebtDialogState extends State<AddDebtDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.debt != null) {
      _nameController.text = widget.debt!.personName;
      _amountController.text = widget.debt!.amount.toString();
      _descriptionController.text = widget.debt!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.debt != null;

    return AlertDialog(
      title: Text(isEdit ? AppStrings.editDebt : AppStrings.addDebt),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.personName,
                  hintText: 'Enter person name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: AppStrings.amount,
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: '₱',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: AppStrings.description,
                  hintText: 'Optional',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
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
          onPressed: _saveDebt,
          child: Text(isEdit ? AppStrings.save : AppStrings.add),
        ),
      ],
    );
  }

  Future<void> _saveDebt() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DebtProvider>();
    final name = _nameController.text.trim();
    final amount = double.parse(_amountController.text);
    final description = _descriptionController.text.trim();

    try {
      if (widget.debt == null) {
        await provider.addDebt(
          personName: name,
          amount: amount,
          type: widget.isIOwe ? DebtType.iOwe : DebtType.owedToMe,
          description: description,
        );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.debtAdded)),
          );
        }
      } else {
        final updatedDebt = widget.debt!.copyWith(
          personName: name,
          amount: amount,
          description: description,
        );
        await provider.updateDebt(updatedDebt);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.debtUpdated)),
          );
        }
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
