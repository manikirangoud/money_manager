import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_manager/modals/activity_modal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_easy_permissions/super_easy_permissions.dart';

class AddActivity extends StatefulWidget {
  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final activitiesModal = ActivityModal(
      name: "", count: 0, caloriesBurned: 0, repetitions: 0, timeStamp: "");
  var buttonText = 'Add activity';
  final formKey = GlobalKey<FormState>();

  final jsonStart = '{"activitiesData":[';
  final jsonEnd = ']}';

  checkPermission() async {
    return await SuperEasyPermissions.isGranted(Permissions.storage);
  }

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
      return null;
    }
  }

  Future writeFile(data) async {
    String previousData = await readFile();

    final file = await localFile;

    if (previousData == null || previousData.length < 2) {
      await file.writeAsString(jsonStart + data + jsonEnd);
    } else {
      await file.writeAsString(
          previousData.substring(0, previousData.length - 2) +
              ',' +
              data +
              jsonEnd);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blue[200],
          child: Container(
            color: Colors.white30,
            child: Form(
              /*autovalidate: true,*/
              key: formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter activity name',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      activitiesModal.name = value ?? "";
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter count',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      activitiesModal.count = int.parse(value ?? "0");
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter repetitions',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      activitiesModal.repetitions = int.parse(value ?? "0");
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter calories burned',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      activitiesModal.caloriesBurned = int.parse(value ?? "0");
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter date',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.datetime,
                    onSaved: (value) {
                      activitiesModal.timeStamp = value ?? "";
                    },
                  ),
                  RaisedButton(
                    child: Text(buttonText),
                    onPressed: () {
                      setState(() {
                        formKey.currentState?.save();
                        Map<String, dynamic> map() => {
                              'name': activitiesModal.name,
                              'count': activitiesModal.count,
                              'repetitions': activitiesModal.repetitions,
                              'caloriesBurned': activitiesModal.caloriesBurned,
                              'timeStamp': activitiesModal.timeStamp
                            };

                        String data = jsonEncode(map());
                        writeFile(data);
                        buttonText = 'Data saved successfully';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
