import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  var _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _datePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        this._selectedDate = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              Container(
                height: 70,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Chosen Date'
                          : 'Pickde Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    TextButton(
                      onPressed: _datePicker,
                      child: Text(
                        'choose date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                child: ElevatedButton(
                  child: Text('Add Transaction'),
                  onPressed: _submitData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
