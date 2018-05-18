extends Node

export var sensitivity = Vector2(0.3,0.3)
export var move_speed = 4.0

var cam_yaw = 0
var cam_pitch = 0
var cam_xform = Quat(Vector3(1,0,0), 0)
var cam_node = null
var tab_pressed = false

func get_cam_rotation():
	return cam_xform

func _ready():
	cam_node = get_node("_Camera")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process(true)

func _input(event):	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if not (Input.is_mouse_button_pressed(1) or Input.is_mouse_button_pressed(2)):
			cam_yaw = fmod(cam_yaw - event.relative.x * sensitivity.x,360)
			cam_pitch = clamp(cam_pitch - event.relative.y * sensitivity.y,-80,80)
			var pitch = Quat(Vector3(1,0,0), deg2rad(cam_pitch))
			cam_xform = Quat(Vector3(0,1,0), deg2rad(cam_yaw)) * pitch
			cam_node.transform = Transform(cam_xform)

func _process(dt):
	var dir = Vector3(0,0,0)
	var speed = move_speed
	
	if Input.is_key_pressed(KEY_W):
		dir += Vector3(0,0,-1)
	if Input.is_key_pressed(KEY_A):
		dir += Vector3(-1,0,0)
	if Input.is_key_pressed(KEY_S):
		dir += Vector3(0,0,1)
	if Input.is_key_pressed(KEY_D):
		dir += Vector3(1,0,0)
	if Input.is_key_pressed(KEY_SHIFT):
		speed *= 2.0
	if Input.is_key_pressed(KEY_CONTROL):
		speed *= 0.5
	if Input.is_key_pressed(KEY_ESCAPE):
		self.get_tree().quit()
	if Input.is_key_pressed(KEY_TAB):
		if not tab_pressed:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		tab_pressed = true
	else:
		tab_pressed = false
	
	if dir.length_squared() > 0:
		var delta_ls = dir.normalized() * (speed * dt)
		var delta_ws = cam_xform.xform(delta_ls)
		self.transform.origin += delta_ws
