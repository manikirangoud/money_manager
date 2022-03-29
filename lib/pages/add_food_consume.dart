import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_manager/modals/food_modal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_easy_permissions/super_easy_permissions.dart';

class AddFoodConsume extends StatefulWidget {
  @override
  _AddFoodConsumeState createState() => _AddFoodConsumeState();
}

class _AddFoodConsumeState extends State<AddFoodConsume> {
  final foodModal = FoodModal(foodName: "");
  var buttonText = 'Add consumed food';
  final formKey = GlobalKey<FormState>();

  final jsonStart = '{"foodData":[';
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
    return File('$path/dataFood.txt');
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
          color: Colors.red[200],
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
                      labelText: 'Enter food name',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      foodModal.foodName = value ?? "";
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter count',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      foodModal.count = int.parse(value ?? "0");
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter food weight',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      foodModal.weight = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter calories',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      foodModal.calories = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter proteins',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      foodModal.proteins = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter carbohydrates',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      foodModal.carbohydrates = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter fibre',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      foodModal.fibre = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter date',
                      fillColor: Colors.black,
                    ),
                    keyboardType: TextInputType.datetime,
                    onSaved: (value) {
                      foodModal.timeStamp = value;
                    },
                  ),
                  RaisedButton(
                    child: Text(buttonText),
                    onPressed: () {
                      setState(() {
                        formKey.currentState?.save();
                        Map<String, dynamic> map() => {
                              'foodName': foodModal.foodName,
                              'count': foodModal.count,
                              'weight': foodModal.weight,
                              'calories': foodModal.calories,
                              'proteins': foodModal.proteins,
                              'carbohydrates': foodModal.carbohydrates,
                              'fibre': foodModal.fibre,
                              'timeStamp': foodModal.timeStamp
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
