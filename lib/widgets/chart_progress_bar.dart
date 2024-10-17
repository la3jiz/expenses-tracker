import 'package:flutter/material.dart';

class ChartProgressBar extends StatelessWidget {
  final String weekDay;
  final double spendingAmount;
  final double spendingAmountPercentage;

  ChartProgressBar(
      this.weekDay, this.spendingAmount, this.spendingAmountPercentage);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              child: Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.15,
                    child: FittedBox(
                      child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    width: 10,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            color: Color.fromRGBO(220, 220, 220, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          heightFactor: spendingAmountPercentage,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10))),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Container(
                    height: constraints.maxHeight * 0.15,
                    child: Text(weekDay),
                  ),
                ],
              ),
            ));
  }
}
