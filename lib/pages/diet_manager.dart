import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_manager/modals/food_modal.dart';
import 'package:money_manager/pages/add_food_consume.dart';
import 'package:path_provider/path_provider.dart';

class DietManager extends StatefulWidget {
  @override
  _DietManagerState createState() => _DietManagerState();
}

class _DietManagerState extends State<DietManager> {
  Future get writeToFile async {
    final appDirectory = await getApplicationDocumentsDirectory();

    return appDirectory.path;
  }

  Future get localFile async {
    final path = await writeToFile;
    return File('$path/dataFood.txt');
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

  List<FoodModal> foodConsumedList = [];
  String data = 'Data here!';

  DateTime dateTime = new DateTime.now();
  String date = "";

  Future<List<FoodModal>> getData(date) async {
    String data = await readFile();

    var tempJson = jsonDecode(data);
    var json = tempJson['foodData'];

    if (foodConsumedList.length != 0) {
      foodConsumedList.clear();
    }
    for (Map<String, dynamic> mapData in json) {
      Iterable<dynamic> values = mapData.values;

      if (date.toString().replaceAll(" ", "") ==
          values.elementAt(7).toString().replaceAll(" ", "")) {
        foodConsumedList.add(FoodModal(
          foodName: values.elementAt(0),
          count: values.elementAt(1),
          weight: values.elementAt(2),
          calories: values.elementAt(3),
          proteins: values.elementAt(4),
          carbohydrates: values.elementAt(5),
          fibre: values.elementAt(6),
          timeStamp: values.elementAt(7),
        ));
      }
    }

    return foodConsumedList;
  }

  @override
  void initState() {
    // TODO: implement initState

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
      color: Colors.red[200],
      child: SafeArea(
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: getData(date),
                builder: (context, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: foodConsumedList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return buildMoneyExpenseItem(
                            foodConsumedList[index], index);
                      },
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      //setDate( 1 );
                    },
                    child: Material(
                      color: Colors.white54,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.equalizer,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
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
                      color: Colors.red[200],
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
                            builder: (context) => AddFoodConsume(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildMoneyExpenseItem(FoodModal foodModal, int index) {
    return Card(
      color: Colors.red[200],
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
                  text: foodModal.count.toString() + " " + foodModal.foodName,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  children: <InlineSpan>[
                    TextSpan(
                      text: ' are consumed. It has ',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                    ),
                    TextSpan(
                      text: foodModal.calories,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' calories, ',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                    ),
                    TextSpan(
                      text: foodModal.proteins,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' proteins, and weighted as ',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                    ),
                    TextSpan(
                      text: foodModal.weight,
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
