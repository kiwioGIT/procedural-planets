tool
extends EditorPlugin

var editing_object_
var regen_button_
var spawn_trees_button_
var restart_shader_button_

func handles(object):
	return object.is_in_group("planet")

func edit(object):
	editing_object_ = object


func make_visible(visible):
	if not visible:
		hide_button()
	else:
		show_button()

func show_button():

	regen_button_ = Button.new()
	regen_button_.text = "regen_planet"
	regen_button_.connect("pressed",self,"regen_planet",[editing_object_])
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU,regen_button_)
	

	spawn_trees_button_ = Button.new()
	spawn_trees_button_.text = "spawn_trees"
	spawn_trees_button_.connect("pressed",self,"spawn_trees",[editing_object_])
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU,spawn_trees_button_)
	


func hide_button():
	if regen_button_:
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU,regen_button_)
		regen_button_.queue_free()
		regen_button_ = null
		
	if spawn_trees_button_:
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU,spawn_trees_button_)
		spawn_trees_button_.queue_free()
		spawn_trees_button_ = null


func regen_planet(object):
	object.generate()

func spawn_trees(obj):
	obj.spawn_trees()

