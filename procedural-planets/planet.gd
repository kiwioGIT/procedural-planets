extends Spatial
tool

export var num_of_trees = 50
onready var packet_treespawn = load("res://trees/TreeSpawn.tscn")

func _ready():
	
	generate()


func _input(event):
	if event.is_action_pressed("regen"):
		generate()





func generate():
	for child in get_children():
		if child.is_in_group("face"):
			child.regenerate_mesh()
	
	var rng = RandomNumberGenerator.new()
	rng.seed = 10
	
	for i in range(num_of_trees):
		var new_tspwn = packet_treespawn.instance()
		add_child(new_tspwn)
		new_tspwn.transform.origin.x = rng.randf_range(-1,1)
		rng.randomize()
		new_tspwn.transform.origin.y = rng.randf_range(-1,1)
		rng.randomize()
		new_tspwn.transform.origin.z = rng.randf_range(-1,1)
		new_tspwn.transform.origin = new_tspwn.transform.origin.normalized() * 2000
		rng.randomize()
		
	
func _process(delta):
	if Input.is_key_pressed(KEY_G):
		generate()
	#var mat = get_node("MeshInstance").get_surface_material(0).set_shader_param("cam_pos",get_parent().get_node("Camera").global_transform.origin)
	#get_node("MeshInstance").mesh.surface_get_material(0).set_shader_param("cam_pos",get_parent().get_node("Camera").global_transform.origin)
