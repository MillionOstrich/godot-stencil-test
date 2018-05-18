extends Node

export var move_speed = 3.0
export var size_speed = 1.0
export var rotate_speed = 0.1
export var rotate_dead_zone = 0.003

var cut_size = 1
var cut_point = Vector3(0,0,0)
var cut_normal = Vector3(0,1,0)
var rotate_point = Vector2(0,0) 
var mouse_delta = Vector2(0,0)

var camera_node = null
var high_node = null
var low_node = null

func get_cut_origin():
	return cut_point
	
func get_cut_normal():
	return cut_normal
	
func get_cut_size():
	return cut_size

func _ready():
	camera_node = get_node("../Camera")
	high_node = get_node("CapHigh")
	low_node = get_node("CapLow")
	cut_point = self.transform.origin
	set_process(true)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_delta += event.relative

func _process(dt):
	var lmb = Input.is_mouse_button_pressed(1)
	var rmb = Input.is_mouse_button_pressed(2)
	
	if mouse_delta.length_squared() > 0:
		if lmb and rmb:
			_process_resize(dt)
		elif lmb:
			_process_translate(dt)
		elif rmb:
			_process_rotate(dt)
		mouse_delta = Vector2(0,0)

func _process_resize(dt):
	#Up/Down motion only so only look at mouse up/down
	cut_size -= mouse_delta.y * size_speed * dt
	cut_size = clamp(cut_size,0.1,10)
	low_node.transform.origin.y = -cut_size
	high_node.transform.origin.y = cut_size

func _process_translate(dt):
	#Up/Down motion only so only look at mouse up/down
	var dy = Vector3(0,mouse_delta.y,0)
	cut_point -= dy * move_speed * dt
	cut_point.y = clamp(cut_point.y, 0,20)
	self.transform.origin = cut_point

func _process_rotate(dt):
	#Rotate plane relative to camera facing direction
	var delta = mouse_delta
	if camera_node != null:
		var rot = camera_node.get_cam_rotation()
		var world_x = rot.xform(Vector3(1,0,0))
		var world_z = rot.xform(Vector3(0,0,1))
		var rel_x = Vector2(world_x.x,world_x.z).normalized()
		var rel_y = Vector2(world_z.x,world_z.z).normalized()
		delta = mouse_delta.x * rel_x + mouse_delta.y * rel_y
	
	#Clamp point within a unit circle around 0,0,0
	rotate_point += delta * rotate_speed * dt
	rotate_point = rotate_point / max(rotate_point.length(), 1)
	
	#Project point up onto surface of half sphere with origin at 0,0,0
	var x = Vector3(rotate_point.x,0,0)
	var y = Vector3(0,sqrt(clamp(1 - rotate_point.length_squared(),0,1)),0)
	var z = Vector3(0,0,rotate_point.y) 
	cut_normal = (x + y + z).normalized()
	
	#Make having the plane perfectly flat easier by pulling nearby angles to flat
	if cut_normal.y > 1 - rotate_dead_zone:
		cut_normal = Vector3(0,1,0)
	
	#Construct basis with up vector = to normal of sphere at point
	if abs(cut_normal.z) < 0.99:
		var f = cut_normal.cross(Vector3(0,0,1)).normalized()
		var r = f.cross(cut_normal)
		self.transform.basis = Basis(r,cut_normal,r.cross(cut_normal))
	else:
		var f = cut_normal.cross(Vector3(0,1,0)).normalized()
		var r = f.cross(cut_normal)
		self.transform.basis = Basis(r,cut_normal,r.cross(cut_normal))
