import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  const Success({Key? key}) : super(key: key);

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
          child: Text('Thi is success page', style: TextStyle(
            fontSize: 20
          ),),
        ),
      ),
    );
  }
}
