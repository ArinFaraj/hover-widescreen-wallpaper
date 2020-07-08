package main

import (
	"github.com/go-flutter-desktop/go-flutter"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(907, 432),
	flutter.WindowMode(flutter.WindowModeBorderless),
	flutter.AddPlugin(&AppBarDraggable{}),
}
