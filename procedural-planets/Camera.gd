extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * 0.5
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * 0.5
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		transform.origin += Vector3(0,0,-1).rotated(Vector3(0,1,0),rotation.y)
	if Input.is_action_pressed("ui_down"):
		transform.origin += Vector3(0,0,1).rotated(Vector3(0,1,0),rotation.y)
	if Input.is_action_pressed("ui_left"):
		transform.origin += Vector3(-1,0,0).rotated(Vector3(0,1,0),rotation.y)
	if Input.is_action_pressed("ui_right"):
		transform.origin += Vector3(1,0,0).rotated(Vector3(0,1,0),rotation.y)
	if Input.is_action_pressed("space"):
		transform.origin += Vector3(0,1,0).rotated(Vector3(0,1,0),rotation.y)
	if Input.is_action_pressed("shift"):
		transform.origin += Vector3(0,-1,0).rotated(Vector3(0,1,0),rotation.y)
