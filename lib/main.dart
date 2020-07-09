/*import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'wideico_icons.dart';
import 'AppStateNotifier.dart';
import 'draggable_plugin.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';

// void main() {
//   debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
//   runApp(MyApp());
// }
bool isDesktop;
bool isWeb;
void main() {
  //debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  if (kIsWeb) {
    isWeb = true;
    isDesktop = false;
  } else {
    isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

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
          home: HomeUI(),
        );
      },
    );
  }
}

class HomeUI extends StatelessWidget {
  const HomeUI({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DraggableAppBar(title: '/WIDESCREENWALLPAPER'),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Platform.operatingSystem,
                  style: TextStyle(fontSize: 18),
                ),
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter your username'),
                )
              ],
            ),
          ),
          if (isDesktop) // Resize Handle
            Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: 0.2,
                child: GestureDetector(
                  child: Icon(Icons.signal_cellular_4_bar),
                  onPanStart: DraggablePlugin.onResizeStart,
                  onPanUpdate: DraggablePlugin.onResizeUpdate,
                ),
              ),
            )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DraggableAppBar extends StatelessWidget implements PreferredSizeWidget {
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
                  text: title,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'BlenderPro'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        if (isDesktop)
          GestureDetector(
            child: appBar,
            onPanStart: DraggablePlugin.onPanStart,
            onPanUpdate: DraggablePlugin.onPanUpdate,
            onDoubleTap: () async => await DraggablePlugin.onMaximize(),
          )
        else
          appBar,
        Container(
            child: Row(children: [
          SizedBox(width: 290),
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
          Switch(
            value: Provider.of<AppStateNotifier>(context).isDarkMode,
            onChanged: (value) =>
                Provider.of<AppStateNotifier>(context, listen: false)
                    .updateTheme(value),
          ),
        ])),
        if (isDesktop)
          Container(
            child: Row(
              children: [
                Expanded(child: SizedBox(height: 45)),
                IconButton(
                  iconSize: 16,
                  icon: Icon(Icons.minimize),
                  onPressed: () async => await DraggablePlugin.onMinimize(),
                ),
                IconButton(
                  iconSize: 15,
                  icon: Icon(Wideico.asset_2),
                  onPressed: () async => await DraggablePlugin.onMaximize(),
                ),
                IconButton(
                  iconSize: 14,
                  icon: Icon(Wideico.asset_1),
                  onPressed: () async => await DraggablePlugin.onClose(),
                ),
              ],
            ),
          )
      ],
    ));
  }

  @override
  Size get preferredSize => new Size.fromHeight(45);
}
