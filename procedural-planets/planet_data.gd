extends Resource

class_name PlanetData


export var smin_kontinents = false
export var noise_map : OpenSimplexNoise
export var kontinent_noise : OpenSimplexNoise
export var kontinent_noise2 : OpenSimplexNoise
export var second_noise_layer : OpenSimplexNoise 
export var sub_noise : OpenSimplexNoise


export var mountain_mask : OpenSimplexNoise 
export var high_mountains : OpenSimplexNoise
export var ocean_mask : OpenSimplexNoise 
export var high_mountains_mask : OpenSimplexNoise


export var ocean_mask_bias = 0.0
export var mountain_mask_bias = 0.0

export var kontinent_border_exponent = 1
export var kontinent_border = 1.0
export var kontinent_bias = 0.0
export var high_mountains_bias = 0.0

export var ocean_surface = 600

export var mountains_power = 1

export var ocean_height = 50
export var ocean_floor = 50
export var elevation = 605
export var elevation2 = 50
export var elevation3 = 20
export var elevation4 = 0

export var high_mountains_elevation = 50
export var kontinent_elevation = 30

export var high_mountains_power = 2

export var beach_smoothing = 5.0

export var shader_mat : Material



export var stupid_lookup_value = 0.1
