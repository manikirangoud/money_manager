import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/pages/activity_manager.dart';
import 'package:money_manager/pages/milestone_manager.dart';
import 'package:super_easy_permissions/super_easy_permissions.dart';
import 'pages/diet_manager.dart';
import 'pages/money_manager.dart';

void main() => runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        primaryTextTheme: TextTheme(
          caption: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var selectedIndex = 0;
  bool permissionGranted = false;

  List fragments = [
    MilestoneManager(),
    DietManager(),
    MoneyManager(),
    ActivityManager()
  ];

  List colors = [
    Colors.blue[200],
    Colors.red[200],
    Colors.green[200],
    Colors.amber[200]
  ];

  @override
  void initState() {
    super.initState();

    requestWritePermission();
  }

  requestWritePermission() async {
    bool permissionStatus =
        await SuperEasyPermissions.isGranted(Permissions.storage);

    if (permissionStatus) {
      setState(() {
        permissionGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fragments[selectedIndex],
      bottomNavigationBar: BottomNavyBar(
        showElevation: true,
        selectedIndex: selectedIndex,
        onItemSelected: (index) => setState(() {
          selectedIndex = index;
        }),
        backgroundColor: colors[selectedIndex],
        items: [
          BottomNavyBarItem(
            icon: Icon(
              Icons.assistant_photo,
              color: Colors.black,
            ),
            title: Text('Milestones',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                )),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.fastfood,
              color: Colors.black,
            ),
            title: Text('Diet Manager',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                )),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.attach_money,
              color: Colors.black,
            ),
            title: Text('Money Manager',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                )),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.watch,
              color: Colors.black,
            ),
            title: Text('Activities',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                )),
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
