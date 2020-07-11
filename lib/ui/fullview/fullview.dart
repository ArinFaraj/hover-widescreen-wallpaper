import 'package:flutter/material.dart';

class Fullview extends StatelessWidget {
  final String url;
  const Fullview({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Stack(
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
            Center(child: Image.network(url))
          ],
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
