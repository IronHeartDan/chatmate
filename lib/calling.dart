import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Calling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calling Danish"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Container(
              color: Colors.deepOrange,
              child: Center(
                child: Text(
                  "Calling...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
