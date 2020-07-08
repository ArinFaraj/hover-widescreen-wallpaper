import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'wideico_icons.dart';
import 'AppStateNotifier.dart';
import 'dart:io';
// void main() {
//   debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
//   runApp(MyApp());
// }

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'R/WIDESCREENWALLPAPER',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            fontFamily: 'BlenderPro',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: Color(0xFF191919),
            fontFamily: 'BlenderPro',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
            appBar: DraggableAppBar(title: "r/WidescreenWallpaper"),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Platform.operatingSystem,
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: Provider.of<AppStateNotifier>(context).isDarkMode,
                    onChanged: (value) =>
                        Provider.of<AppStateNotifier>(context, listen: false)
                            .updateTheme(value),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
      color: Colors.transparent,
      child: Row(
        children: [
          SizedBox(height: 45, width: 20),
          RichText(
            text: TextSpan(
              text: 'R',
              style: TextStyle(
                  color: Color(0xFF00C2FF),
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'BlenderPro'),
              children: <TextSpan>[
                TextSpan(
                  text: '/WIDESCREENWALLPAPER',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'BlenderPro'),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          DropdownButton<String>(
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: 'One',
            onChanged: (String value) {},
          ),
          Expanded(child: SizedBox(height: 45)),
          IconButton(
            iconSize: 16,
            icon: Icon(Icons.minimize),
            onPressed: () async =>
                await platform_channel_draggable.invokeMethod("onMinimize"),
          ),
          IconButton(
            iconSize: 15,
            icon: Icon(Wideico.asset_2),
            onPressed: () async =>
                await platform_channel_draggable.invokeMethod("onMaximize"),
          ),
          IconButton(
            iconSize: 14,
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
      child: appBar,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onDoubleTap: onDoubleTap,
    );
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

  void onDoubleTap() async {
    await platform_channel_draggable.invokeMethod("onMaximize");
  }
}
