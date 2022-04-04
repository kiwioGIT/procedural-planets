extends KinematicBody

var current_wapon = ""
var finalrotationdegreesz
var add_velocity = Vector3.ZERO


var velocity = Vector3(0,0,0)
export var ACCELERATION = 4
export var DEF_ACC = 3
export var DE_ACCELERATION = 3
export var MOVE_SPEED = 15
export var JUMP_FORCE = 55
export var GRAVITY = 1.6
export var MAX_FALL_SPEED = 500
export var mouse_captured = false
export var slide = false
const H_LOOK_SENS = 0.1
const V_LOOK_SENS = 0.1
var shootcooldown = 0
onready var X = get_node("X")
onready var Y = X.get_node("Y")
onready var Z = Y.get_node("Z")
onready var tick_rate = $tick_rate
onready var pre_cam = Z.get_node("pre_cam_origin")
onready var cam = pre_cam.get_node("cam_origin")
onready var realcam = cam.get_node("Camera")

var max_jet_speed = 70
var jet_speed = 8
var move_vec = Vector3()
var camdistance = 0
var y_velo = 0

var UP = Vector3(0,1,0)
var gravity_direction
var normal


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	
	if event is InputEventMouseMotion:
		cam.rotation_degrees.x -= event.relative.y * V_LOOK_SENS
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -89, 89)
		pre_cam.rotation_degrees.y -= event.relative.x * H_LOOK_SENS


func nat(var x):
	if x == 0:
		return 0
	return x / abs(x)


func _physics_process(delta):
		
		get_node("Y-indi").global_transform.origin = global_transform.origin + Vector3.UP * 5
		get_node("X-indi").global_transform.origin = global_transform.origin + Vector3.LEFT * 5
		get_node("Z-indi").global_transform.origin = global_transform.origin + Vector3.FORWARD * 5
		normal = (get_parent().get_node("planet").global_transform.origin - global_transform.origin).normalized()
		#normal = normal.rotated(Vector3(0,1,0),-rotation.y)
		
		var Axis = (global_transform.origin - cam.get_node("MeshInstance3").global_transform.origin).normalized()
		
		
		
		
		Axis -= normal * normal.dot(Axis)
		
		Axis = Axis.normalized()
		
		var Bxis = normal.cross(Axis).normalized()
		
		transform.basis = Basis(Bxis,normal,Axis)
		
		Y.rotation.y = pre_cam.rotation.y
		
		get_node("MeshInstance4").global_transform.origin = global_transform.origin + Bxis * 5
		

		get_node("MeshInstance2").global_transform.origin = global_transform.origin + normal * 5
		
		

		var move_vec = Vector3.ZERO
		if (Input.is_action_pressed("ui_down")):
			move_vec += Axis;
		if (Input.is_action_pressed("ui_up")):
			move_vec -= Axis;
		if (Input.is_action_pressed("ui_left")):
			move_vec += Bxis;
		if (Input.is_action_pressed("ui_right")):
			move_vec -= Bxis;
			
			
		#if is_on_floor():
		#	velocity -= normal * velocity.dot(normal)
			
			
		move_vec = move_vec.normalized()
		velocity += normal * GRAVITY
		if velocity.length() < 3:
			velocity *= 0.6 
		
		#SPLIT VELOCITY TO HORIZONTAL AND VERTICAL
		var vertical_velocity = velocity.dot(normal)
		var horizontal_veloctiy = velocity - normal*vertical_velocity
		
		
		if is_on_floor():
			vertical_velocity = 0
		
		
		
		if horizontal_veloctiy.length() < MOVE_SPEED:
			horizontal_veloctiy += move_vec if horizontal_veloctiy.length() > 3 else move_vec * 3
		else:
			horizontal_veloctiy = horizontal_veloctiy.normalized()*MOVE_SPEED
		
		var deacel = horizontal_veloctiy.normalized()*DE_ACCELERATION*0.1
		
		if horizontal_veloctiy.dot(deacel)>0:
			horizontal_veloctiy -= deacel
		else:
			horizontal_veloctiy = Vector3(0,0,0)
		
		if is_on_floor() and Input.is_action_pressed("space"):
			vertical_velocity -= JUMP_FORCE
			#velocity -= normal*JUMP_FORCE*2
		
		#CONNECT HORIZONTAL AND VERTICAL VELOCITY TOGETHER
		velocity = horizontal_veloctiy + normal*vertical_velocity
		
		
		
		
	
		
		
		
		move_and_slide(velocity,-normal)
		if Input.is_action_just_pressed("shift"):
			velocity = Vector3.ZERO
		#velocity = move_and_slide(velocity + add_velocity, Vector3(0,1,0))
		add_velocity = Vector3.ZERO









func get_distance_to_3d(start : Vector3, end : Vector3):
	return sqrt(pow(get_distance_to_2d(Vector2(start.x,start.z),Vector2(end.x,end.z)),2)+pow(start.y-end.y,2))

func get_distance_to_2d(start : Vector2, end : Vector2):
	return sqrt(pow(start.x-end.x,2)+pow(start.y-end.y,2))
