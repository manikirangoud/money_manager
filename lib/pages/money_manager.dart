import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/modals/money_modal.dart';
import 'package:money_manager/pages/circular_button.dart';
import 'package:path_provider/path_provider.dart';

import 'add_money_expense.dart';

class MoneyManager extends StatefulWidget {
  @override
  _MoneyManagerState createState() => _MoneyManagerState();
}

class _MoneyManagerState extends State<MoneyManager> {
  Future get writeToFile async {
    final appDirectory = await getApplicationDocumentsDirectory();

    return appDirectory.path;
  }

  Future get localFile async {
    final path = await writeToFile;
    return File('$path/data.txt');
  }

  Future readFile() async {
    try {
      final file = await localFile;
      return await file.readAsString();
    } catch (e) {
      return e.toString();
    }
  }

  Future writeFile(data) async {
    String previousData = await readFile();

    final file = await localFile;

    if (previousData != null) {
      await file.writeAsString("");
    }
  }

  List<MoneyExpenseModal> moneyExpenseList = [];
  String data = 'Data here!';

  DateTime dateTime = DateTime.now();
  String date = "";

  Future<List<MoneyExpenseModal>> getData(date) async {
    String data = await readFile();

    var tempJson = jsonDecode(data);
    var json = tempJson['expenseData'];

    if (moneyExpenseList.length != 0) {
      moneyExpenseList.clear();
    }
    for (Map<String, dynamic> mapData in json) {
      Iterable<dynamic> values = mapData.values;

      if (date.toString().replaceAll(" ", "") ==
          values.elementAt(3).toString().replaceAll(" ", "")) {
        moneyExpenseList.add(MoneyExpenseModal(
            id: values.elementAt(0),
            amountSpent: values.elementAt(1),
            spentName: values.elementAt(2),
            timeStamp: values.elementAt(3),
            categories: values.elementAt(4),
            subCategories: values.elementAt(5),
            type: values.elementAt(6),
            locationName: values.elementAt(7)));
      }
    }

    return moneyExpenseList;
  }

  @override
  void initState() {
    // TODO: implement initState

    /* setState(() {

      readFile().then((onValue) {

        var tempJson = jsonDecode(onValue);
        var json = tempJson['expenseData'];
        for(Map<String, dynamic> mapData in json){

          Iterable<dynamic> values = mapData.values;

          moneyExpenseList.add(MoneyExpenseModel(
              id: values.elementAt(0),
              amountSpent: values.elementAt(1),
              spentName: values.elementAt(2),
              timeStamp: values.elementAt(3),
              categories: values.elementAt(4),
              subCategories: values.elementAt(5),
              type: values.elementAt(6),
              locationName: values.elementAt(7)
          ));
        }
        data = moneyExpenseList.length.toString();
      });
    });*/

    date = dateTime.day.toString() +
        ' - ' +
        dateTime.month.toString() +
        ' - ' +
        dateTime.year.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.green[200],
      child: SafeArea(
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: getData(date),
                builder: (context, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: moneyExpenseList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return buildMoneyExpenseItem(
                            moneyExpenseList[index], index);
                      },
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircularButton(
                    iconData: Icons.equalizer,
                    onPressed: () {},
                  ),
                  CircularButton(
                    iconData: Icons.chevron_left,
                    onPressed: () {},
                  ),
                  GestureDetector(
                    onTap: () {
                      setDate(-1);
                    },
                    child: Material(
                      color: Colors.white54,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.chevron_left,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onDateSelected();
                    },
                    child: Card(
                      color: Colors.green[200],
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        color: Colors.white54,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setDate(1);
                    },
                    child: Material(
                      color: Colors.white54,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.chevron_right,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMoneyExpense(),
                          ));
                    },
                    child: Material(
                      color: Colors.white54,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.add,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    elevation: 0.0,
                    heroTag: "fab1",
                    hoverElevation: 0.0,
                    child: IconButton(
                      iconSize: 20.0,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMoneyExpense(),
                            ));
                      },
                    ),
                    backgroundColor: Colors.white54,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildMoneyExpenseItem(MoneyExpenseModal moneyExpenseModal, int index) {
    return Card(
      color: Colors.green[200],
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2.0,
      margin: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
      semanticContainer: true,
      child: Container(
        color: Colors.white54,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  text: moneyExpenseModal.amountSpent.toString(),
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  children: <InlineSpan>[
                    TextSpan(
                      text: ' amount was spent for ',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                    ),
                    TextSpan(
                      text: moneyExpenseModal.spentName,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' under ',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                    ),
                    TextSpan(
                      text: moneyExpenseModal.categories,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' category, on ',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                    ),
                    TextSpan(
                      text: moneyExpenseModal.timeStamp,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future onDateSelected() async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2016),
        lastDate: DateTime(2030));

    if (dateTime != null) {
      setState(() {
        date = dateTime.day.toString() +
            ' - ' +
            dateTime.month.toString() +
            ' - ' +
            dateTime.year.toString();
      });
    }
  }

  setDate(state) {
    if (state == -1) {
      setState(() {
        dateTime = dateTime.subtract(Duration(days: 1));
        date = dateTime.day.toString() +
            ' - ' +
            dateTime.month.toString() +
            ' - ' +
            dateTime.year.toString();
      });
    } else if (state == 1) {
      setState(() {
        dateTime = dateTime.add(Duration(days: 1));
        date = dateTime.day.toString() +
            ' - ' +
            dateTime.month.toString() +
            ' - ' +
            dateTime.year.toString();
      });
    }
  }
}
