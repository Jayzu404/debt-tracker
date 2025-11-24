import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/debts_owed/debts_owed_screen.dart';
import '../presentation/screens/debts_to_collect/debts_to_collect_screen.dart';
import '../presentation/screens/transactions/transactions_screen.dart';
import '../presentation/screens/more/more_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const DebtsOwedScreen(),
    const DebtsToCollectScreen(),
    const TransactionsScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withAlpha(128),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.dashboard,
                  label: AppStrings.navDashboard,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.arrow_upward,
                  label: AppStrings.navIOwe,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.arrow_downward,
                  label: AppStrings.navToCollect,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.history,
                  label: AppStrings.navHistory,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.more_horiz,
                  label: AppStrings.navMore,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.grey400,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : AppColors.grey400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
