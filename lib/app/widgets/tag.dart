import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String data;

  const Tag(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).primaryColorDark,
      ),
      child: Center(
        child: Text(
          data,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
