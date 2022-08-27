extends DirectionalLight
tool

func _ready():
	rotation.y = 0

func _process(delta):
	rotation.y += delta*0.01
	get_node("MeshInstance2").get_surface_material(0).set_shader_param("angle",-rotation.y + (90*PI/180))
