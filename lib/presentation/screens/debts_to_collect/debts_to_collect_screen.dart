import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/debt_model.dart';
import '../../providers/debt_provider.dart';
import '../../widgets/debt_card.dart';
import '../debts_owed/add_debt_dialog.dart';
import '../debts_owed/debt_detail_screen.dart';
import '../debts_owed/record_payment_dialog.dart';

class DebtsToCollectScreen extends StatelessWidget {
  const DebtsToCollectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navToCollect),
      ),
      body: Consumer<DebtProvider>(
        builder: (context, provider, child) {
          final debts = provider.debtsOwedToMe
              .where((debt) => !debt.isSettled)
              .toList();

          if (debts.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: debts.length,
            itemBuilder: (context, index) {
              final debt = debts[index];
              return DebtCard(
                debt: debt,
                onTap: () => _navigateToDetail(context, debt),
                onPayment: () => _showPaymentDialog(context, debt),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.money_off,
            size: 80,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 16),
          const Text(
            'No debts to collect!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No one owes you money',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddDebtDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Debt'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.debtOwedToMe,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDebtDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddDebtDialog(isIOwe: false),
    );
  }

  void _showPaymentDialog(BuildContext context, DebtModel debt) {
    showDialog(
      context: context,
      builder: (context) => RecordPaymentDialog(debt: debt),
    );
  }

  void _navigateToDetail(BuildContext context, DebtModel debt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DebtDetailScreen(debt: debt),
      ),
    );
  }
}