import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_utils.dart';
import '../../providers/debt_provider.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/transaction_item.dart';
import '../debts_owed/add_debt_dialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navDashboard),
      ),
      body: Consumer<DebtProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStatistics(context, provider),
                const SizedBox(height: 20),
                _buildQuickActions(context, provider),
                const SizedBox(height: 20),
                _buildRecentTransactions(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, DebtProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,  // FIXED: Increased from 1.3 to make cards shorter
          children: [
            StatCard(
              title: AppStrings.totalIOwe,
              value: AppDateUtils.formatCurrency(provider.totalDebtIOwe),
              icon: Icons.arrow_upward,
              color: AppColors.debtIOwe,
            ),
            StatCard(
              title: AppStrings.totalToCollect,
              value: AppDateUtils.formatCurrency(provider.totalDebtOwedToMe),
              icon: Icons.arrow_downward,
              color: AppColors.debtOwedToMe,
            ),
            StatCard(
              title: AppStrings.activeDebts,
              value: provider.activeDebtsCount.toString(),
              icon: Icons.pending_actions,
              color: AppColors.warning,
            ),
            StatCard(
              title: AppStrings.settledDebts,
              value: provider.settledDebtsCount.toString(),
              icon: Icons.check_circle,
              color: AppColors.success,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, DebtProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.quickActions,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showAddDebtDialog(context, isIOwe: true),
                icon: const Icon(Icons.add),
                label: const Text('Add Debt I Owe'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.debtIOwe,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showAddDebtDialog(context, isIOwe: false),
                icon: const Icon(Icons.add),
                label: const Text('Add Debt to Collect'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.debtOwedToMe,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(BuildContext context, DebtProvider provider) {
    final transactions = provider.allTransactions.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.recentTransactions,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (transactions.isNotEmpty)
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 12),
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
                          AppStrings.noTransactions,
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
    );
  }

  void _showAddDebtDialog(BuildContext context, {required bool isIOwe}) {
    showDialog(
      context: context,
      builder: (context) => AddDebtDialog(isIOwe: isIOwe),
    );
  }
}