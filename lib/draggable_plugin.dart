import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppStateNotifier.dart';
import 'wideico_icons.dart';

// ignore: must_be_immutable
class DraggableAppBar extends StatelessWidget implements PreferredSizeWidget {
  Container appBar;
  bool isDesktop;
  bool isWeb;

  DraggableAppBar(
      {@required String title,
      @required bool isDesktop,
      @required bool isWeb}) {
    this.isDesktop = isDesktop;
    this.isWeb = isWeb;
    this.appBar = Container(
      color: Colors.transparent,
      child: Row(
        children: [
          SizedBox(height: 45, width: 20),
          RichText(
            text: TextSpan(
              text: title.substring(0, 1),
              style: TextStyle(
                  color: Color(0xFF00C2FF),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'BlenderPro'),
              children: <TextSpan>[
                TextSpan(
                  text: title.substring(1),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
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
          SizedBox(width: 280),
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

class DraggablePlugin {
  static const platform_channel_draggable =
      MethodChannel('samples.go-flutter.dev/draggable');

  static setFullScreen(bool value) async {
    await platform_channel_draggable.invokeMethod("onMinimize");
  }

  static onMaximize() async {
    await platform_channel_draggable.invokeMethod("onMaximize");
  }

  static onMinimize() async {
    await platform_channel_draggable.invokeMethod("onMinimize");
  }

  static onClose() async {
    await platform_channel_draggable.invokeMethod("onClose");
  }

  static void onPanUpdate(DragUpdateDetails details) async {
    await platform_channel_draggable.invokeMethod('onPanUpdate');
  }

  static void onPanStart(DragStartDetails details) async {
    await platform_channel_draggable.invokeMethod('onPanStart',
        {"dx": details.globalPosition.dx, "dy": details.globalPosition.dy});
  }

  static void onResizeUpdate(DragUpdateDetails details) async {
    await platform_channel_draggable.invokeMethod('onResizeUpdate');
  }

  static void onResizeStart(DragStartDetails details) async {
    await platform_channel_draggable.invokeMethod('onResizeStart',
        {"dx": details.globalPosition.dx, "dy": details.globalPosition.dy});
  }
/*
  static Future<bool> isFullScreen() async {
    return await channel.invokeMethod("getFullScreen");
  }*/
}
