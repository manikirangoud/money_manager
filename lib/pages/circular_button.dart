import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;
  final String? heroTag;

  const CircularButton(
      {Key? key,
      this.iconData = Icons.arrow_back,
      this.onPressed,
      this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () {},
      elevation: 0.0,
      heroTag: heroTag,
      hoverElevation: 0.0,
      child: IconButton(
        iconSize: 20.0,
        icon: Icon(
          iconData,
          color: Colors.black,
        ),
        onPressed: onPressed,
      ),
      backgroundColor: Colors.white54,
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white54,
      shape: const CircleBorder(),
      child: IconButton(
        iconSize: 20.0,
        icon: Icon(
          iconData,
          color: Colors.black,
        ),
        onPressed: onPressed,
      ),
    );
  }*/
}
