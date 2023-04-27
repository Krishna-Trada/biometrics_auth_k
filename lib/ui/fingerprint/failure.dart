import 'package:flutter/material.dart';

class Failure extends StatelessWidget {
  const Failure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context);
        Navigator.pop(context);
        return false;
      },
      child: const Scaffold(
        body: Center(
          child: Text('Thi is failure page', style: TextStyle(
              fontSize: 20
          ),),
        ),
      ),
    );
  }
}
