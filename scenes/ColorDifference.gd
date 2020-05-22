extends Node2D

onready var colorbox = $VBoxContainer/ColorBlocks/ColorRect
onready var maincolor = $VBoxContainer/ColorBlocks/MainColor
onready var colorpicker = $ColorPicker
onready var difference_label = $VBoxContainer/DifferenceLabel

func rgb2xyz(rgb):
	var X = 0.412453 * rgb.r + \
		0.357580 * rgb.g + \
		0.180423 * rgb.b
		
	var Y = 0.212671 * rgb.r + \
		0.715160 * rgb.g + \
		0.072169 * rgb.b
		
	var Z = 0.019334 * rgb.r + \
		0.119193 * rgb.g + \
		0.950227 * rgb.b 
	
	return Vector3(X, Y, Z)

func colordiff(color1, color2):
	return (rgb2xyz(color1) - rgb2xyz(color2)).length()

func _on_ColorPicker_color_changed(color):
	colorbox.color = color
	difference_label.text = str(colordiff(colorbox.color, maincolor.color))

func _on_Button_pressed():
	maincolor.color = colorpicker.color
	difference_label.text = str(colordiff(colorbox.color, maincolor.color))
