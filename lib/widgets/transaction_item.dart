import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function deleteTransaction;

  const TransactionItem({
    required this.transaction,
    required this.deleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
                child: Text('\$${transaction.amount.toStringAsFixed(0)}')),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 500
            ? ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).errorColor,
                  onPrimary: Colors.white, // Text color
                ),
                onPressed: () {
                  deleteTransaction(transaction.id);
                },
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  deleteTransaction(transaction.id);
                },
              ),
      ),
    );
  }
}
