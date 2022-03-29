import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_manager/modals/money_modal.dart';
import 'package:money_manager/pages/app_head.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_easy_permissions/super_easy_permissions.dart';

class AddMoneyExpense extends StatefulWidget {
  @override
  _AddMoneyExpenseState createState() => _AddMoneyExpenseState();
}

class _AddMoneyExpenseState extends State<AddMoneyExpense> {
  final moneyExpenseModel = MoneyExpenseModal();
  var buttonText = 'Add Expense';
  final formKey = GlobalKey<FormState>();

  final jsonStart = '{"expenseData":[';
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
    return File('$path/data.txt');
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.green.shade100,
          child: Column(
            children: [
              const AppHead(),
              Expanded(
                child: Form(
                  /*autovalidate: true,*/
                  key: formKey,
                  child: SingleChildScrollView(
                    physics:
                        const ScrollPhysics(parent: BouncingScrollPhysics()),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(16.0),
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter Id',
                            fillColor: Colors.black,
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            moneyExpenseModel.id = int.parse(value ?? "0");
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter Spent Amount',
                            fillColor: Colors.black,
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            moneyExpenseModel.amountSpent =
                                double.parse(value ?? "0.0");
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter name of spent',
                            fillColor: Colors.black,
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            moneyExpenseModel.spentName = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter Spent Date',
                            fillColor: Colors.black,
                          ),
                          keyboardType: TextInputType.datetime,
                          onSaved: (value) {
                            moneyExpenseModel.timeStamp = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter Category',
                            fillColor: Colors.black,
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            moneyExpenseModel.categories = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter Sub Category',
                            fillColor: Colors.black,
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            moneyExpenseModel.subCategories = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter type',
                            fillColor: Colors.black,
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            moneyExpenseModel.type = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter location',
                            fillColor: Colors.black,
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            moneyExpenseModel.locationName = value;
                          },
                        ),
                        RaisedButton(
                          child: Text(buttonText),
                          onPressed: () {
                            setState(() {
                              formKey.currentState?.save();
                              Map<String, dynamic> map() => {
                                    'id': moneyExpenseModel.id,
                                    'amountSpent':
                                        moneyExpenseModel.amountSpent,
                                    'spentName': moneyExpenseModel.spentName,
                                    'timeStamp': moneyExpenseModel.timeStamp,
                                    'categories': moneyExpenseModel.categories,
                                    'subCategories':
                                        moneyExpenseModel.subCategories,
                                    'type': moneyExpenseModel.type,
                                    'locationName':
                                        moneyExpenseModel.locationName
                                  };

                              String data = jsonEncode(map());
                              writeFile(data);
                              buttonText = 'Data saved succesfully';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
