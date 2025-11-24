import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/debt_model.dart';
import '../../providers/debt_provider.dart';
import '../../widgets/transaction_item.dart';
import 'add_debt_dialog.dart';
import 'record_payment_dialog.dart';

class DebtDetailScreen extends StatelessWidget {
  final DebtModel debt;

  const DebtDetailScreen({
    super.key,
    required this.debt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(debt.personName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Consumer<DebtProvider>(
        builder: (context, provider, child) {
          final currentDebt = provider.allDebts
              .firstWhere((d) => d.id == debt.id, orElse: () => debt);
          final transactions = provider.getTransactionsByDebtId(debt.id);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDebtSummary(currentDebt),
                const Divider(height: 1),
                _buildTransactionsList(transactions),
              ],
            ),
          );
        },
      ),
      floatingActionButton: debt.isSettled
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showPaymentDialog(context),
              icon: const Icon(Icons.payment),
              label: const Text('Record Payment'),
            ),
    );
  }

  Widget _buildDebtSummary(DebtModel debt) {
    final color = debt.type == DebtType.iOwe
        ? AppColors.debtIOwe
        : AppColors.debtOwedToMe;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: color.withAlpha((0.1 * 255).round()),
      child: Column(
        children: [
          Text(
            AppDateUtils.formatCurrency(debt.remainingAmount),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.remaining,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryItem(
                label: AppStrings.total,
                value: AppDateUtils.formatCurrency(debt.amount),
                color: AppColors.textPrimary,
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.grey300,
              ),
              _buildSummaryItem(
                label: AppStrings.paid,
                value: AppDateUtils.formatCurrency(debt.paidAmount),
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: debt.amount > 0 ? debt.paidAmount / debt.amount : 0,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${((debt.paidAmount / debt.amount) * 100).toStringAsFixed(0)}% paid',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          if (debt.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.note,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      debt.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'Created ${AppDateUtils.formatRelativeDate(debt.createdAt)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsList(List transactions) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${transactions.length} payments',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          transactions.isEmpty
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 48,
                            color: AppColors.grey300,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No payments yet',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Card(
                  child: Column(
                    children: transactions.map((transaction) {
                      return TransactionItem(transaction: transaction);
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddDebtDialog(
        isIOwe: debt.type == DebtType.iOwe,
        debt: debt,
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => RecordPaymentDialog(debt: debt),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteDebt),
        content: const Text(
            'Are you sure you want to delete this debt? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<DebtProvider>().deleteDebt(debt.id);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.debtDeleted)),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}
