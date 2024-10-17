import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;
  TransactionList(this.transactions, this._deleteTransaction);

  //this works when your turn TransactionList class to statefulWidget
  // void _deleteTransaction(String id) {
  //   List<Transaction> _filtredList =
  //       widget.transactions.where((tx) => tx.id != id).toList();
  //   setState(() {
  //     widget.transactions = _filtredList;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  Container(
                      height: constraints.maxHeight * 0.7,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      )),
                ],
              );
            })
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                return TransactionItem(
                    transaction: transactions[index],
                    deleteTransaction: _deleteTransaction);
              },
            ),
    );
  }
}
