extends Node

export(Material) var stencil_material = null
export(int,1,10) var material_count = 1

var materials = []
var cut_node = null

func _ready():
	cut_node = get_node("../Cutter")
	
	var mesh = get_node("Mesh")
	for i in range(0,material_count):
		_add_material(mesh.get_surface_material(i))
	
	set_process(true)

func _process(dt):
	if cut_node != null:
		var position = cut_node.get_cut_origin()
		var normal = cut_node.get_cut_normal()
		var size = cut_node.get_cut_size()
		for mat in materials:
			mat.set_shader_param("cut_position",position)
			mat.set_shader_param("cut_normal",normal)
			mat.set_shader_param("cut_size",size)

func _add_material(mat):
	if mat != null:
		if mat is ShaderMaterial and materials.find(mat) == -1:
			materials.append(mat)
		_add_material(mat.get_next_pass())
