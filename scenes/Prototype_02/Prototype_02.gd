extends Control

export var bg2fg_relation := 2.0
export var speed_factor := 10.0

onready var background = $"Layers/Background"
onready var foreground = $"Layers/Foreground"
onready var bg_material = background.material
onready var fg_material = foreground.material
onready var masks_menu = $"MaskSelector/OptionButton"

var bg_hue : float
var fg_hue : float
var fg_masks := []
var score := 0.0


func _ready() -> void:
    randomize()
    
    bg_hue = randf()
    fg_hue = randf()
    
    while fg_hue == bg_hue:
        fg_hue = randf()
    
    bg_material.set_shader_param("Color Uniform", colorFromHue(bg_hue))
    fg_material.set_shader_param("Color Uniform", colorFromHue(fg_hue))
    
    for node in (masks_menu.get_children().slice(1, -1)):  # first element is an autoinserted PopupMenu
        fg_masks.append(node.texture)
        masks_menu.add_item(node.name)
        node.queue_free()
        
    set_fg_mask(fg_masks[0])
    masks_menu.select(0)


func _physics_process(delta: float) -> void:
    rotate_hues(delta)
    background.update()
    foreground.update()


func rotate_hues(delta: float) -> void:
    bg_hue = fmod((bg_hue + delta / 10 * bg2fg_relation), 1.0)
    fg_hue = fmod((fg_hue - delta / 10), -1.0)
    bg_material.set_shader_param("BackgroundColor", colorFromHue(bg_hue))
    fg_material.set_shader_param("ForegroundColor", colorFromHue(fg_hue))
    

func _on_Layers_Button_released():
    var diff = colordiff(\
        bg_material.get_shader_param("Color Uniform"),\
        fg_material.get_shader_param("Color Uniform")
    )
    score += int(100 * (1 - diff))
    $"ScoreBoard/Score".text = str(score)


# Foreground mask relatedfunctions

func set_fg_mask(mask: Texture):
    bg_material.set_shader_param("ForegroundMask", mask)
    fg_material.set_shader_param("ForegroundMask", mask)
    
func _on_MaskMenu_item_selected(id):
    set_fg_mask(fg_masks[id])
    
func _on_MaskMenu_ButtonLeft_pressed():
    masks_menu.selected = masks_menu.selected - 1 \
        if masks_menu.selected > 0 else masks_menu.get_item_count() - 1
    set_fg_mask(fg_masks[masks_menu.selected])
    
func _on_MaskMenu_ButtonRicht_pressed():
    masks_menu.selected = (masks_menu.selected + 1) % masks_menu.get_item_count()
    set_fg_mask(fg_masks[masks_menu.selected])


# Utility Functions

func colorFromHue(h: float) -> Color:
    return Color.from_hsv(h, .7, .5)
    
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
