package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"
	"github.com/go-gl/glfw/v3.3/glfw"
)

// AppBarDraggable is a plugin that makes moving the bordreless window possible
type AppBarDraggable struct {
	window        *glfw.Window
	cursorPosY    int
	cursorPosX    int
	fromMaximized bool
	wBig          int
	w             int
	h             int
}

var _ flutter.Plugin = &AppBarDraggable{}     // compile-time type check
var _ flutter.PluginGLFW = &AppBarDraggable{} // compile-time type check
// AppBarDraggable struct must implement InitPlugin and InitPluginGLFW

// InitPlugin creates a MethodChannel for "samples.go-flutter.dev/draggable"
func (p *AppBarDraggable) InitPlugin(messenger plugin.BinaryMessenger) error {
	channel := plugin.NewMethodChannel(messenger, "samples.go-flutter.dev/draggable", plugin.StandardMethodCodec{})
	channel.HandleFunc("onPanStart", p.onPanStart)
	channel.HandleFuncSync("onPanUpdate", p.onPanUpdate) // MUST RUN ON THE MAIN THREAD (use of HandleFuncSync)
	channel.HandleFunc("onResizeStart", p.onResizeStart)
	channel.HandleFuncSync("onResizeUpdate", p.onResizeUpdate)
	channel.HandleFunc("onClose", p.onClose)
	channel.HandleFunc("onMaximize", p.onMaximize)
	channel.HandleFunc("onMinimize", p.onMinimize)
	return nil
}

// InitPluginGLFW is used to gain control over the glfw.Window
func (p *AppBarDraggable) InitPluginGLFW(window *glfw.Window) error {
	p.window = window
	p.window.SetSizeLimits(700, 400, 16000, 16000)
	return nil
}

// onPanStart/onPanUpdate a golang / flutter implemantation of:
// "GLFW how to drag undecorated window without lag"
// https://stackoverflow.com/a/46205940
func (p *AppBarDraggable) onPanStart(arguments interface{}) (reply interface{}, err error) {
	argumentsMap := arguments.(map[interface{}]interface{})
	p.cursorPosX = int(argumentsMap["dx"].(float64))
	p.cursorPosY = int(argumentsMap["dy"].(float64))
	if p.window.GetAttrib(glfw.Maximized) == 1 {
		p.fromMaximized = true
		p.wBig, _ = p.window.GetSize()
		p.window.Restore()
		_, y := p.window.GetPos()
		w, _ := p.window.GetSize()
		p.window.SetPos(p.cursorPosX-(w*p.cursorPosX/p.wBig), y)
	} else {
		p.fromMaximized = false
	}
	return nil, nil
}

// onPanUpdate calls GLFW functions that aren't thread safe.
// to run function on the main go-flutter thread, use HandleFuncSync instead of HandleFunc!
func (p *AppBarDraggable) onPanUpdate(arguments interface{}) (reply interface{}, err error) {
	xpos, ypos := p.window.GetCursorPos() // This function must only be called from the main thread.
	deltaX := int(xpos) - p.cursorPosX
	deltaY := int(ypos) - p.cursorPosY
	var x, y int // This function must only be called from the main thread.
	if p.fromMaximized {
		x, y = p.window.GetPos()
		w, _ := p.window.GetSize()
		x += p.cursorPosX - (w * p.cursorPosX / p.wBig) // This function must only be called from the main thread.
	} else {
		x, y = p.window.GetPos() // This function must only be called from the main thread.
	}
	p.window.SetPos(x+deltaX, y+deltaY) // This function must only be called from the main thread.

	return nil, nil
}

func (p *AppBarDraggable) onResizeStart(arguments interface{}) (reply interface{}, err error) {
	argumentsMap := arguments.(map[interface{}]interface{})
	p.cursorPosX = int(argumentsMap["dx"].(float64))
	p.cursorPosY = int(argumentsMap["dy"].(float64))
	p.w, p.h = p.window.GetSize()

	return nil, nil
}

func (p *AppBarDraggable) onResizeUpdate(arguments interface{}) (reply interface{}, err error) {
	xpos, ypos := p.window.GetCursorPos()
	deltaX := int(xpos) - p.cursorPosX
	deltaY := int(ypos) - p.cursorPosY
	currentW, currentH := p.window.GetSize()
	limW, limH := 700, 400
	newW := p.w + deltaX
	newH := p.h + deltaY
	if newW >= limW {
		currentW = newW
		p.window.SetSize(newW, currentH)
	}
	if newH >= limH {
		p.window.SetSize(currentW, newH)
	}

	return nil, nil
}

func (p *AppBarDraggable) onClose(arguments interface{}) (reply interface{}, err error) {
	// This function may be called from any thread. Access is not synchronized.
	p.window.SetShouldClose(true)
	return nil, nil
}
func (p *AppBarDraggable) onMaximize(arguments interface{}) (reply interface{}, err error) {
	if p.window.GetAttrib(glfw.Maximized) == 1 {
		p.window.Restore()
	} else {
		p.window.Maximize()
	}
	// https://www.glfw.org/docs/latest/group__window.html
	return nil, nil
}
func (p *AppBarDraggable) onMinimize(arguments interface{}) (reply interface{}, err error) {
	p.window.Iconify()
	return nil, nil
}
