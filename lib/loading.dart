import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: 170,),
              Text('loading', style: TextStyle( color: const Color(0xFFD8D8D8),
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              )),
              Container(height: 250,),
            ],
          );
  }
}
