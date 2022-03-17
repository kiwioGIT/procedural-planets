extends Spatial





func _ready():
	for child in get_children():
		if !child.is_in_group("nomesh"):
			child.regenerate_mesh()
			
			
		
	pass 

func _process(delta):
	pass
	#var mat = get_node("MeshInstance").get_surface_material(0).set_shader_param("cam_pos",get_parent().get_node("Camera").global_transform.origin)
	#get_node("MeshInstance").mesh.surface_get_material(0).set_shader_param("cam_pos",get_parent().get_node("Camera").global_transform.origin)

