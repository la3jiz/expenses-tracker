import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './resources/dummy_transaction_list.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() {
  //disable device landscape
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transactions Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // final List<Transaction> _userTransaction = DummyTransactions.transactions;
  final List<Transaction> _userTransaction = [];

  bool _showChart = false;

  void _showChartHandler(val) {
    setState(() {
      _showChart = val;
    });
  }

//add a transaction
  void _addTransaction(String title, double amount, DateTime date) =>
      setState(() {
        _userTransaction.add(new Transaction(
            id: 't${_userTransaction.length}',
            title: title,
            amount: amount,
            date: date));
      });

//show add transaction card
  void addNewTransaction(BuildContext context) {
    // _ in builder is a context parameter which builder needs but we will never use thats why we used _
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(_addTransaction);
        });
  }

  List<Transaction> get _recentTransaction {
    return _userTransaction
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state.name);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

//android znavigatoin bar wigdet
    final PreferredSizeWidget androidAppBar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text('Transactions Tracker App'),
      actions: [
        IconButton(
            onPressed: () {
              addNewTransaction(context);
            },
            icon: Icon(Icons.add))
      ],
    );

    //Ios navigatoin bar wigdet
    final iosAppBar = CupertinoNavigationBar(
      middle: Text('Transactions Tracker App'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {
                addNewTransaction(context);
              },
              child: Icon(CupertinoIcons.add))
        ],
      ),
    );

    final appBar = Platform.isIOS ? iosAppBar : androidAppBar;

    final _txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.8,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );
    
    final _appBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Show Chart',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) => _showChartHandler(val)),
              ],
            ),
          if (!isLandscape)
            (Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.2,
              child: Chart(_recentTransaction),
            )),
          if (!isLandscape) _txListWidget,
          if (isLandscape)
            _showChart
                ? (Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.6,
                    child: Chart(_recentTransaction),
                  ))
                : _txListWidget
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _appBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: _appBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    backgroundColor: Colors.amber[600],
                    onPressed: () {
                      addNewTransaction(context);
                    },
                  ),
          );
  }
}
