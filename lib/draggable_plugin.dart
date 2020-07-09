import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

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
/*
  static Future<bool> isFullScreen() async {
    return await channel.invokeMethod("getFullScreen");
  }*/
}
