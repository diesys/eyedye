extends Node

onready var touches_txt : Label = $Container/VBoxContainer
onready var touches_label : Label = $Container/VBoxContainer/Points
onready var bg : = $bg/bgimg
#onready var animation : = $bg/animation
onready var hue_timer : = $bg/timer_hue

# init
var touch_count := 0
var count = 0

# animation timing must be same as "wait time" to use all colors
var duration_divider = 10

# color 
var S = .7
var L = .5


func _ready() -> void:
	update_touches()


func _process(delta):
	rotate_hue()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		touch_count += 1
		update_touches()
		#rand_bg_color(bg)
		#wheel_bg_anim(bg)
		# is_equal_approx(a:float, b:float)


func update_touches() -> void:
	#touches_label.text = str(touch_count)
	#var color_distance = max(max(abs(bg.get_modulate()[0] - touches_txt.get_modulate()[0]), abs(bg.get_modulate()[1] - touches_txt.get_modulate()[1])), abs(bg.get_modulate()[2] - touches_txt.get_modulate()[2]))
	var color_distance = abs(bg.get_modulate()[0] - touches_txt.get_modulate()[0]) + abs(bg.get_modulate()[1] - touches_txt.get_modulate()[1]) + abs(bg.get_modulate()[2] - touches_txt.get_modulate()[2])
	print(bg.get_modulate(), '\n *', touches_txt.get_modulate())
	#print(bg.get_modulate() - touches_txt.get_modulate())
	touches_label.text = str(color_distance)

#func rand_bg_color1(element) -> void:
#	var new_color = Color.from_hsv(randf(),.5,.5)
#	element.modulate = new_color

func rotate_hue() -> void:
	var new_hue = hue_timer.get_time_left()/duration_divider
	var new_bg_clr = Color.from_hsv(new_hue, .7, .5)
	var new_txt_clr = Color.from_hsv(new_hue * 2, .7, .5)
	bg.modulate = new_bg_clr
	touches_txt.modulate = new_txt_clr
	
func rand_color() -> Vector3:
	var new_color = Color.from_hsv(randf(),.5,.5)
	return new_color
