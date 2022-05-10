extends Spatial
tool

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var treespwn = load("res://trees/TreeSpawn.tscn")
var max_new_objs = 5
var obj_spawn_chance = 0.2
var first_layer_hiearchy = 0
var min_random_dist = 50
var max_random_dist = 80
var last_hi = 2

export var spawnable_trees : PoolStringArray
export var hiearchy : PoolIntArray

func _ready():
	pass
	#spawn_tree()

# Called when the node enters the scene tree for the first time.
func spawn_tree():
	
	get_node("RayCast").look_at(Vector3.ZERO,Vector3.UP)
	if !get_node("RayCast").is_colliding():
		print("no coll")
		return
	var rng = RandomNumberGenerator.new()
	rng.seed = 1000*(global_transform.origin.x + global_transform.origin.y + global_transform.origin.z) * first_layer_hiearchy 
	var spawnable_tree
	while(true):
		rng.randomize()
		spawnable_tree = rng.randi_range(0,spawnable_trees.size()-1)
		if hiearchy[spawnable_tree] == first_layer_hiearchy:
			break
		
	var spawn_pos = get_node("RayCast").get_collision_point()
	var new_tree = load(spawnable_trees[spawnable_tree]).instance()
	
	
	get_parent().add_child(new_tree)
	new_tree.global_transform.origin = spawn_pos
	new_tree.look_at(Vector3.ZERO,Vector3.UP)
	
	if first_layer_hiearchy == last_hi:
		queue_free()
		return

	rng.randomize()
	for i in range(max_new_objs):
		if rng.randf() > obj_spawn_chance:
			continue
		var new_tspwn = treespwn.instance()
		new_tspwn.first_layer_hiearchy = first_layer_hiearchy + 1
		new_tspwn.hiearchy = hiearchy
		new_tspwn.spawnable_trees = spawnable_trees
		get_parent().add_child(new_tspwn)
		var random_pos_x = rng.randf_range(min_random_dist,max_random_dist)
		random_pos_x *= -1 if rng.randf() > 0.5 else 1
		rng.randomize()
		var random_pos_y = rng.randf_range(min_random_dist,max_random_dist)
		random_pos_y *= -1 if rng.randf() > 0.5 else 1
		rng.randomize()
		var random_pos_z = rng.randf_range(min_random_dist,max_random_dist)
		random_pos_z *= -1 if rng.randf() > 0.5 else 1
		rng.randomize()
		new_tspwn.global_transform.origin = global_transform.origin + Vector3(random_pos_x,random_pos_y,random_pos_z)
	
	
	queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_node("TreeMesh").global_transform.origin)
	get_node("RayCast").look_at(Vector3.ZERO,Vector3.UP)
	#if Input.is_action_just_pressed("gen_tree"):
	#	spawn_tree()
	pass
