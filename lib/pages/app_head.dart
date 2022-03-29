import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/pages/circular_button.dart';

class AppHead extends StatelessWidget {
  const AppHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          FloatingActionButton.small(
            onPressed: () {},
            elevation: 0.0,
            heroTag: "fab1",
            hoverElevation: 0.0,
            child: IconButton(
              iconSize: 20.0,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            backgroundColor: Colors.white54,
          ),
          CircularButton(
            iconData: Icons.arrow_back,
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop(animated: true);
              }
            },
          ),
          const SizedBox(
            width: 16,
          ),
          const Text('Title')
        ],
      ),
    );
  }
}
