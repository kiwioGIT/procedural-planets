extends MultiMeshInstance

var start_inst = 100
var max_dist = 20
var max_inst = 1000000
var shmat = load("res://grass_blade_shade_mat.tres")

func add_instances():
	
	var ins_to_spawn = clamp(multimesh.visible_instance_count*2,start_inst,max_inst)
	
	for i in range(multimesh.visible_instance_count,ins_to_spawn):
		var tr = Transform().scaled(Vector3(0.1,0.1,0.1))
		multimesh.mesh.surface_set_material(0,shmat)
		tr.origin = Vector3(randf()*max_dist,0,randf()*max_dist) - Vector3(max_dist/2,0,max_dist/2)
		randomize()
		tr = tr.rotated(Vector3.UP, rand_range(-PI, PI))
		multimesh.set_instance_transform(i,tr)
	
	multimesh.visible_instance_count = ins_to_spawn
	#get_node("CanvasLayer/Control/Label").text = str(ins_to_spawn)

func _ready():
	multimesh.instance_count = max_inst
	add_instances()

func _input(event):
	if event.is_action_pressed("space"):
		add_instances()


func _process(delta):
	pass
	#get_node("CanvasLayer/Control/Label2").text = str(1/delta)
