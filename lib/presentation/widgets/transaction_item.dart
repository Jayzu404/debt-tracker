import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().add_jm().format(transaction.createdAt);
    final isPayment = transaction.type == TransactionType.payment;
    final amountColor = isPayment ? Colors.red : Colors.green;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isPayment ? Colors.red.shade50 : Colors.green.shade50,
        child: Icon(
          isPayment ? Icons.arrow_upward : Icons.arrow_downward,
          color: isPayment ? Colors.red : Colors.green,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              transaction.personName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Chip(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            label: Text(
              isPayment ? 'Paid' : 'Received',
              style: TextStyle(
                color: isPayment ? Colors.red : Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            backgroundColor:
                isPayment ? Colors.red.shade50 : Colors.green.shade50,
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (transaction.note.isNotEmpty)
            Text(
              transaction.note,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            date,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: Text(
        '₱${transaction.amount.toStringAsFixed(2)}',
        style: TextStyle(
          color: amountColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
