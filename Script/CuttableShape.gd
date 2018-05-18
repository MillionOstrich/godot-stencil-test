extends Node

export(Material) var stencil_material = null
export(int,1,10) var material_count = 1

var materials = []
var cut_node = null

func _ready():
	cut_node = get_node("../Cutter")
	
	var mesh = get_node("Mesh")
	for i in range(0,material_count):
		var mat = mesh.get_surface_material(i)
		if mat is ShaderMaterial:
			materials.append(mat)
			mat.set_next_pass(stencil_material)
	
	if stencil_material != null:
		materials.append(stencil_material)
	
	set_process(true)
	
func _process(delta):
	if cut_node != null:
		var position = cut_node.get_cut_origin()
		var normal = cut_node.get_cut_normal()
		var size = cut_node.get_cut_size()
		for mat in materials:
			mat.set_shader_param("cut_position",position)
			mat.set_shader_param("cut_normal",normal)
			mat.set_shader_param("cut_size",size)

