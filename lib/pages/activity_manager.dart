import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_manager/modals/activity_modal.dart';
import 'package:money_manager/pages/add_activity.dart';
import 'package:path_provider/path_provider.dart';

class ActivityManager extends StatefulWidget {
  @override
  _ActivityManagerState createState() => _ActivityManagerState();
}

class _ActivityManagerState extends State<ActivityManager> {
  Future get writeToFile async {
    final appDirectory = await getApplicationDocumentsDirectory();

    return appDirectory.path;
  }

  Future get localFile async {
    final path = await writeToFile;
    return File('$path/dataActivities.txt');
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

  List<ActivityModal> activitiesList = [];
  String data1 = 'Data here!';

  DateTime dateTime = DateTime.now();
  String date = "";

  Future<List<ActivityModal>> getData(date) async {
    String data = await readFile();

    var tempJson = jsonDecode(data);
    var json = tempJson['activitiesData'];

    if (activitiesList.length != 0) {
      activitiesList.clear();
    }
    for (Map<String, dynamic> mapData in json) {
      Iterable<dynamic> values = mapData.values;

      if (date.toString().replaceAll(" ", "") ==
          values.elementAt(4).toString().replaceAll(" ", "")) {
        activitiesList.add(ActivityModal(
          name: values.elementAt(0),
          count: values.elementAt(1),
          repetitions: values.elementAt(2),
          caloriesBurned: values.elementAt(3),
          timeStamp: values.elementAt(4),
        ));
      }
    }

    return activitiesList;
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
      color: Colors.amber[200],
      child: SafeArea(
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: getData(date),
                builder: (context, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: activitiesList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return buildMoneyExpenseItem(
                            activitiesList[index], index);
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
                      color: Colors.amber[200],
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
                            builder: (context) => AddActivity(),
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

  buildMoneyExpenseItem(ActivityModal activityModal, int index) {
    return Card(
      color: Colors.amber[200],
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
                  text: 'You had performed ',
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w300),
                  children: <InlineSpan>[
                    TextSpan(
                      text: activityModal.count.toString() +
                          ' ' +
                          activityModal.name +
                          ', ',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: activityModal.repetitions.toString(),
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' repetitions and ',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                    ),
                    TextSpan(
                      text: activityModal.caloriesBurned.toString(),
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' calories burned ',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
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
