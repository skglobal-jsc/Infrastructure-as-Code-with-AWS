import 'package:flutter/material.dart';

class PopupLoading extends StatelessWidget {
  final String text;
  PopupLoading({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black54,
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width*.8,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(text),
            Container(height: 10,),
            CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))
          ])
    ));
  }

}
