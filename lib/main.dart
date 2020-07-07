import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'movie.dart';
import 'wideico_icons.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'R/WIDESCREENWALLPAPER',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: 'BlenderPro',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: DraggableAppBar(title: "r/WidescreenWallpaper"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                Movie.s.toString(),
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DraggableAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const platform_channel_draggable =
      MethodChannel('samples.go-flutter.dev/draggable');

  Container appBar;

  DraggableAppBar({@required String title}) {
    this.appBar = Container(
      child: Row(
        children: [
          SizedBox(width: 20),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'R/',
                style: TextStyle(
                    color: Color(0xFF00C2FF),
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'BlenderPro'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'WIDESCREENWALLPAPER',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'BlenderPro'),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            iconSize: 14,
            icon: Icon(Wideico.asset_2),
            onPressed: () async =>
                await platform_channel_draggable.invokeMethod("onClose"),
          ),
          IconButton(
            iconSize: 13,
            icon: Icon(
              Wideico.asset_1,
              size: 13,
            ),
            onPressed: () async =>
                await platform_channel_draggable.invokeMethod("onClose"),
          ),
          IconButton(
            iconSize: 13,
            icon: Icon(Wideico.asset_1),
            onPressed: () async =>
                await platform_channel_draggable.invokeMethod("onClose"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: appBar, onPanStart: onPanStart, onPanUpdate: onPanUpdate);
  }

  @override
  Size get preferredSize => new Size.fromHeight(45);

  void onPanUpdate(DragUpdateDetails details) async {
    await platform_channel_draggable.invokeMethod('onPanUpdate');
  }

  void onPanStart(DragStartDetails details) async {
    await platform_channel_draggable.invokeMethod('onPanStart',
        {"dx": details.globalPosition.dx, "dy": details.globalPosition.dy});
  }
}
