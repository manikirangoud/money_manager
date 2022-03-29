import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_manager/modals/food_modal.dart';
import 'package:money_manager/modals/milestone_modal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_easy_permissions/super_easy_permissions.dart';

class AddMilestone extends StatefulWidget {
  @override
  _AddMilestoneState createState() => _AddMilestoneState();
}

class _AddMilestoneState extends State<AddMilestone> {
  final milestoneModal = MilestoneModal();
  var buttonText = 'Add milestone';
  final formKey = GlobalKey<FormState>();

  final jsonStart = '{"milestonesData":[';
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
    return File('$path/dataMilestones.txt');
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
                      labelText: 'Enter milestone name',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      milestoneModal.name = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter target days',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      milestoneModal.targetDays = int.parse(value ?? "0");
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter date',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.datetime,
                    onSaved: (value) {
                      milestoneModal.timeStamp = value;
                    },
                  ),
                  RaisedButton(
                    child: Text(buttonText),
                    onPressed: () {
                      setState(() {
                        formKey.currentState?.save();
                        Map<String, dynamic> map() => {
                              'name': milestoneModal.name,
                              'targetDays': milestoneModal.targetDays,
                              'timeStamp': milestoneModal.timeStamp
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
