extends Spatial

var def_cam_pos

func _ready():
	get_node("RayCast").cast_to = get_node("Camera").transform.origin
	def_cam_pos = get_node("Camera").transform.origin

func _process(delta):
	if get_node("RayCast").is_colliding():
		get_node("Camera").global_transform.origin = get_node("RayCast").get_collision_point()
	else:
		get_node("Camera").transform.origin = def_cam_pos
