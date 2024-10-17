import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_progress_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  @override
  List<Map<String, Object>> get _recentweekTransaction {
    return List.generate(7, (index) {
      double totalAmount = 0.0;
      final weekDay = DateTime.now().subtract((Duration(days: index)));
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalAmount += recentTransactions[i].amount;
        }
      }
      print(DateFormat.E().format(weekDay));
      print(totalAmount);

      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalAmount
      };
    }).reversed.toList();
  }

  double get _totalAmountSpending {
    return _recentweekTransaction.fold(0.0, (sum, element) {
      return sum + (element['amount'] as double);
    });
  }

  Widget build(BuildContext context) {
    print(_recentweekTransaction);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _recentweekTransaction.map((tx) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartProgressBar(
                  tx['day'] as String,
                  tx['amount'] as double,
                  _totalAmountSpending == 0
                      ? 0
                      : (tx['amount'] as double) / _totalAmountSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
