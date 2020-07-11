import 'package:flutter/material.dart';

class Fullview extends StatelessWidget {
  final String url;
  const Fullview({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Stack(
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
          Center(
            child: Image.network(
              url,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}
