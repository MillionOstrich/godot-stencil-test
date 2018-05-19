extends Node

var spot_node = null
var directional_node = null
var point_node = null

func _ready():
	spot_node = get_node("SpotLight")
	directional_node = get_node("DirectionalLight")
	point_node = get_node("PointLight")

func _input(event):
	if event is InputEventKey and not event.is_echo() and event.is_pressed():
		if event.get_scancode() == KEY_1:
			spot_node.set_visible(not spot_node.is_visible())
		elif event.get_scancode() == KEY_2:
			directional_node.set_visible(not directional_node.is_visible())
		elif event.get_scancode() == KEY_3:
			point_node.set_visible(not point_node.is_visible())
