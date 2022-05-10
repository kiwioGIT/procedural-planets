extends MeshInstance
tool

export var normal : Vector3
export var mat : ShaderMaterial
var noise_map : OpenSimplexNoise = load("res://nicoe.tres")
var mountain_mask : OpenSimplexNoise = load("res://mountain_mask.tres")
var ocean_mask : OpenSimplexNoise = load("res://ocean_mask.tres")
var second_noise_layer : OpenSimplexNoise = load("res://layer_2.tres")
var sub_noise : OpenSimplexNoise = load("res://sub_noise.tres")
var ocean_height = 50
var ocean_floor = 50

var ocean_surface = 600

var elevation = 605
var elevation2 = 60
var elevation3 = 20
var elevation4 = 0

func regenerate_mesh():
	
	
	
	
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var vertex_array = PoolVector3Array()
	var uv_array = PoolVector3Array()
	var normal_array = PoolVector3Array()
	var index_array = PoolIntArray()
	
	var resolution = 500
	var num_vertices = resolution*resolution
	var num_indexes = (resolution-1)*(resolution-1)*6
	
	vertex_array.resize(num_vertices)
	uv_array.resize(num_vertices)
	normal_array.resize(num_vertices)
	index_array.resize(num_indexes)
	
	var Axis = Vector3(normal.y,normal.z,normal.x)
	var Bxis = normal.cross(Axis)
	var tri_index = 0
	
	
	
	for y in range(resolution):
		for x in range(resolution):
			var i = x + y * resolution
			var percent = Vector2(x,y)/(resolution-1) 
			#var pouc = normal + (percent.x-0.5) * 2 * Axis + (percent.y-0.5) * 2 * Bxis
			var pouc = normal - Axis - Bxis + (Axis*x*2/(resolution-1)) + (Bxis*y*2/(resolution-1))
			vertex_array[i] = pouc.normalized() * get_height(pouc)
			if x != resolution-1 and y != resolution-1:
				index_array[tri_index] = i+resolution
				index_array[tri_index+1] = i+resolution+1
				index_array[tri_index+2] = i
				
				index_array[tri_index+3] = i+resolution+1
				index_array[tri_index+4] = i+1
				index_array[tri_index+5] = i
				
				tri_index += 6
	for a in range(0,index_array.size(),3):
		var b = a+1
		var c = b+1
		var ab = vertex_array[index_array[b]] -vertex_array[index_array[a]]
		var bc = vertex_array[index_array[c]] -vertex_array[index_array[b]]
		var ca = vertex_array[index_array[a]] -vertex_array[index_array[c]]
		
		var ab_bc = ab.cross(bc) * -1.0
		var bc_ca = bc.cross(ca) * -1.0
		var ca_ab = ca.cross(ab) * -1.0
		
		normal_array[index_array[a]] += ab_bc + bc_ca + ca_ab
		normal_array[index_array[b]] += ab_bc + bc_ca + ca_ab
		normal_array[index_array[c]] += ab_bc + bc_ca + ca_ab
	for i in range(normal_array.size()):
		normal_array[i] = normal_array[i].normalized()
	
	arrays[Mesh.ARRAY_VERTEX] = vertex_array
	arrays[Mesh.ARRAY_NORMAL] = normal_array
	arrays[Mesh.ARRAY_INDEX] = index_array
	arrays[Mesh.ARRAY_TEX_UV] = uv_array
	
	call_deferred("_update_mesh",arrays)
	
func _update_mesh(arrays):
	print("again")
	var _mesh = ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
	mat.set_shader_param("elevation",elevation)
	mat.set_shader_param("elevation2",elevation2)
	mat.set_shader_param("ocean_surface_height",ocean_surface)
	_mesh.surface_set_material(0,mat)
	
	
	
	mesh = _mesh
	
	get_node("StaticBody/CollisionShape").shape = mesh.create_trimesh_shape()
	
	
func get_height(var pouc):
	var height = 0
	height += elevation
	# (elevation + max(0,0.3+mountain_mask.get_noise_3dv(pouc*100))*(abs(noise_map.get_noise_3dv(pouc*100)) * elevation2) + max(0,0.4+ocean_mask.get_noise_3dv(pouc*100))*(abs(sub_noise.get_noise_3dv(pouc*100)) * elevation3))# + (second_noise_layer.get_noise_3dv(pouc*100)*pouc*elevation3) + (sub_noise.get_noise_3dv(pouc*100)*pouc*elevation4);
	var mounmask = mountain_mask.get_noise_3dv(pouc*100)
	var mountains =  1-abs(clamp(noise_map.get_noise_3dv(pouc*100)*1.8,-1,1))
	#mountains *= mounmask
	mountains = mountains*mountains*mountains#*mountains
	mounmask = (mounmask + 1)/2
	mountains *= mounmask
	
	
	var ocean =  max(0,sub_noise.get_noise_3dv(pouc*100)*1.8)*((mounmask*-1)+1)
	mountains -= ocean/3
	ocean = smin(ocean*ocean_height,ocean_floor,0.5)
	
	
	height -= ocean
	
	var little_blobs = second_noise_layer.get_noise_3dv(pouc*100)
	height += little_blobs*elevation3
	
	
	height += mountains*elevation2
	
	
	var dist2oceansurface = height - ocean_surface
	var expdist2oceansurface = exp(1/(dist2oceansurface))
	dist2oceansurface *= expdist2oceansurface
	
	
	
	
	return height

func smin(var a, var b, var k):
  var h = clamp(0.5 + 0.5*(a-b)/k, 0.0, 1.0);
  return lerp(a, b, h) - k*h*(1.0-h);
