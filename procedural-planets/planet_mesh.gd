extends MeshInstance
tool

export var normal : Vector3



func regenerate_mesh(planet_data : PlanetData):
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var vertex_array = PoolVector3Array()
	var uv_array = PoolVector3Array()
	var normal_array = PoolVector3Array()
	var index_array = PoolIntArray()
	
	var resolution = 200
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
			vertex_array[i] = pouc.normalized() * get_height_remake(pouc,planet_data,false)
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
	
	call_deferred("_update_mesh",arrays,planet_data)
	
func _update_mesh(arrays,planet_data : PlanetData):
	print("again")
	var _mesh = ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
	var mat = get_surface_material(0)
	#mat.set_shader_param("elevation",planet_data.elevation1)
	#mat.set_shader_param("elevation2",planet_data.elevation2)
	#mat.set_shader_param("ocean_surface_height",planet_data.ocean_surface)
	_mesh.surface_set_material(0,mat)
	
	mesh = _mesh
	get_node("StaticBody/CollisionShape").shape = mesh.create_trimesh_shape()
	
	

func get_height(var pouc,planet_data : PlanetData,pass_check):
	var height = 0
	
	height += planet_data.elevation
	var kontinent
	if planet_data.smin_kontinents:
		kontinent =  smin(planet_data.kontinent_noise.get_noise_3dv(pouc*100)+planet_data.kontinent_bias,planet_data.kontinent_noise2.get_noise_3dv(pouc*100)+planet_data.kontinent_bias,0.9)
	else:
		kontinent = planet_data.kontinent_noise.get_noise_3dv(pouc*100)
	height -= smin(-1*kontinent * planet_data.kontinent_elevation,0,0.8)
	var kontinent_mul = clamp(abs(pow(kontinent*planet_data.kontinent_border,planet_data.kontinent_border_exponent)),-1,1)
	if kontinent < 0:
		kontinent_mul *= -1
	# (elevation + max(0,0.3+mountain_mask.get_noise_3dv(pouc*100))*(abs(noise_map.get_noise_3dv(pouc*100)) * elevation2) + max(0,0.4+ocean_mask.get_noise_3dv(pouc*100))*(abs(sub_noise.get_noise_3dv(pouc*100)) * elevation3))# + (second_noise_layer.get_noise_3dv(pouc*100)*pouc*elevation3) + (sub_noise.get_noise_3dv(pouc*100)*pouc*elevation4);
	var mounmask = clamp(planet_data.mountain_mask.get_noise_3dv(pouc*100)+planet_data.mountain_mask_bias,-1,1)
	var mountains =  1-abs(clamp(planet_data.noise_map.get_noise_3dv(pouc*100)*1.8,-1,1))
	
	mountains = pow(mountains,planet_data.mountains_power)
	mounmask = (mounmask + 1)/2
	mountains *= mounmask
	
	#var ocean =  max(0,planet_data.sub_noise.get_noise_3dv(pouc*100)*1.8)*((mounmask*-1)+1)+planet_data.ocean_mask_bias
	#ocean = smin(ocean*planet_data.ocean_height,planet_data.ocean_floor,0.5)
	#height += ocean if kontinent < 0 else 0
	var ocean = (planet_data.sub_noise.get_noise_3dv(pouc*100)+1)/2 * min(0,kontinent)
	height += ocean * planet_data.ocean_height if kontinent < 0 else 0
	mountains = max(0,mountains)
	var little_blobs = planet_data.second_noise_layer.get_noise_3dv(pouc*100)
	height += little_blobs*planet_data.elevation3
	height += mountains*planet_data.elevation2 * max(0,kontinent_mul)
	
	var high_mountains = planet_data.high_mountains.get_noise_3dv(pouc*100)
	var high_mountains_mask = clamp(planet_data.high_mountains_mask.get_noise_3dv(pouc*100)*8+planet_data.high_mountains_bias,0,1)
	high_mountains = pow(high_mountains,planet_data.high_mountains_power) * (height-planet_data.ocean_surface) * high_mountains_mask
	height += max(high_mountains*planet_data.high_mountains_elevation,0)

	#final smoothing
	#var dist2oceansurface = height - planet_data.ocean_surface
	#var smoothed = clamp(max(0,pow(dist2oceansurface/planet_data.beach_smoothing,2)),-1,1)
	#height = dist2oceansurface*smoothed + planet_data.ocean_surface
	

	return height

func scalmp_( f, sc):
	return clamp(((f-0.5)*sc)+0.5,0.0,1.0)


func get_height_remake(pouc,planet_data : PlanetData,pass_check):
	var height = 0
	#height += planet_data.elevation1
	#height += pow(-smin((-planet_data.mask1.get_noise_3dv(pouc*100)-1)/2,0,0.1),3) * planet_data.elevation2 * ridgidNoise(pouc*100,[planet_data.layers,planet_data.persistence,planet_data.lacunarity,planet_data.scale_,planet_data.multiplier,planet_data.power,planet_data.gain,planet_data.verticalShift])
	var continent = planet_data.noise_map1.get_noise_3dv(pouc * 100)
	
	var ocean = -planet_data.ocean_floor + continent * 0.15
	continent = smin(continent,ocean,-0.2)
	if continent < 0:
		continent *= planet_data.elevation5
	
	var mountains_mask = (planet_data.noise_map2.get_noise_3dv(pouc*100)+1)/2
	var mountains = ridgidNoise(pouc * 100,[planet_data.layers,planet_data.persistence,planet_data.lacunarity,planet_data.scale_,planet_data.multiplier,planet_data.power,planet_data.gain,planet_data.verticalShift]) * mountains_mask
	
	height = continent + mountains + planet_data.elevation1
	
	return height


func ridgidNoise(pos,params):
	#Extract parameters for readability
	var offset = Vector3(0,0,0)
	var numLayers = int(params[0]);
	var persistence = params[1];
	var lacunarity = params[2];
	var scale_ = params[3];
	var multiplier = params[4];
	var power = params[5];
	var gain = params[6];
	var verticalShift = params[7];

	# Sum up noise layers
	var noiseSum = 0;
	var amplitude = 1;
	var frequency = scale;
	var ridgeWeight = 1;

	for i in range(numLayers):
		var nos = OpenSimplexNoise.new()
		nos.octaves = 1
		var noiseVal = 1 - abs(nos.get_noise_3dv(pos * frequency + offset));
		noiseVal = pow(abs(noiseVal), power);
		noiseVal *= ridgeWeight;
		ridgeWeight = clamp(noiseVal * gain,0,1);

		noiseSum += noiseVal * amplitude;
		amplitude *= persistence;
		frequency *= lacunarity;
	return noiseSum * multiplier + verticalShift;


# Sample the noise several times at small offsets from the centre and average the result
# This reduces some of the harsh jaggedness that can occur
func smoothedRidgidNoise(pos,params):
	var sphereNormal = pos.normalized();
	var axisA = sphereNormal.cross(Vector3(0,1,0));
	var axisB = sphereNormal.cross(axisA);

	var offsetDst = 1 * 0.01;
	var sample0 = ridgidNoise(pos, params);
	var sample1 = ridgidNoise(pos - axisA * offsetDst, params);
	var sample2 = ridgidNoise(pos + axisA * offsetDst, params);
	var sample3 = ridgidNoise(pos - axisB * offsetDst, params);
	var sample4 = ridgidNoise(pos + axisB * offsetDst, params);
	return (sample0 + sample1 + sample2 + sample3 + sample4) / 5;


func smin(var a, var b, var k):
  var h = clamp(0.5 + 0.5*(a-b)/k, 0.0, 1.0);
  return lerp(a, b, h) - k*h*(1.0-h);

func scalmp(f,sc,min_,max_):
	return clamp(((f-0.5)*sc)+0.5,min_,max_)



