import 'package:flutter/material.dart';

class EmptyFolder extends StatelessWidget {
  final Widget child;
  final bool isEmpty;
  const EmptyFolder({Key? key, required this.child, this.isEmpty = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isEmpty) return child;
    return Container(
      child: Image.asset(
        'assets/5_Something Wrong.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
