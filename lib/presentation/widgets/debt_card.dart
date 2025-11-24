import 'package:flutter/material.dart';
import '../../data/models/debt_model.dart';

class DebtCard extends StatelessWidget {
  final dynamic debt;
  final VoidCallback? onTap;
  final VoidCallback? onPayment;

  const DebtCard({super.key, required this.debt, this.onTap, this.onPayment});

  @override
  Widget build(BuildContext context) {
    final double amount = (debt?.amount ?? 0.0) as double;
    final double paid = (debt?.paidAmount ?? 0.0) as double;
    final progress = amount > 0 ? (paid / amount).clamp(0.0, 1.0) : 0.0;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(debt?.personName ?? 'Person',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      debt?.description ?? '',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Progress bar with semantics for accessibility
                    Semantics(
                      label: 'Debt payment progress',
                      value: '${(progress * 100).toStringAsFixed(0)} percent',
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade200,
                        color: progress >= 1.0
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${(progress * 100).toStringAsFixed(0)}% paid',
                            style: const TextStyle(fontSize: 12)),
                        Text(
                          '₱${amount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: (debt?.type == DebtType.iOwe)
                                  ? Colors.red
                                  : Colors.green),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.payment),
                    onPressed: onPayment,
                    tooltip: 'Record payment',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
