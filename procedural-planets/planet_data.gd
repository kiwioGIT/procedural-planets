extends Resource

class_name PlanetData

export var layers = 1

export var noise_map1 : OpenSimplexNoise
export var noise_map2 : OpenSimplexNoise
export var noise_map3 : OpenSimplexNoise
export var noise_map4 : OpenSimplexNoise 
export var noise_map5 : OpenSimplexNoise


export var mask1 : OpenSimplexNoise 
export var mask2: OpenSimplexNoise
export var mask3 : OpenSimplexNoise 
export var mask4 : OpenSimplexNoise

export var mountain_blend = 1.0;

export var bias1 = 0.0
export var bias2 = 0.0

export var persistence = 0.0
export var lacunarity  = 0.0
export var scale_  = 0.0
export var multiplier = 0.0
export var power  = 0.0
export var gain  = 0.0
export var verticalShift  = 0.0


export var ocean_surface = 600

export var mountains_power = 1



export var elevation1 = 605
export var elevation2 = 50
export var elevation3 = 20
export var elevation4 = 0
export var elevation5 = 0
export var elevation6 = 0


export var ocean_height = 50
export var ocean_floor = 50



export var high_mountains_power = 2

export var beach_smoothing = 5.0

export var shader_mat : Material



export var stupid_lookup_value = 0.1
