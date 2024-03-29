extends Node2D

export(int) var width = 600
export(int) var height = 200

onready var tilemap = $TileMap

var temperature = {}
var moistrue = {}
var altitude = {}
var biome = {}
var openSimplexNoise = OpenSimplexNoise.new()

func _ready():
	randomize()
	temperature = generate_map(300, 5)
	moistrue = generate_map(300, 5)
	altitude = generate_map(150, 5)
	set_tile(width, height)

func generate_map(per, oct):
	openSimplexNoise.seed = randi()
	openSimplexNoise.period = per
	openSimplexNoise.octaves = oct
	
	var gridName = {}
	
	for x in width:
		for y in height: 
			var rand := 2*abs(openSimplexNoise.get_noise_2d(x, y))
			gridName[Vector2(x,y)] = rand
	return gridName

func set_tile(width, height):
	for x in width:
		for y in height:
			var pos = Vector2(x, y)
			var alt = altitude[pos]
			var temp = temperature[pos]
			var moist = moistrue[pos]
			
			#Ocean
			if alt < 0.2:
				tilemap.set_cellv(pos, 8)
			
			#Beach
			elif between(alt, 0.2, 0.25):
				tilemap.set_cellv(pos, 6)
			
			#Other Biomes
			elif between(alt, 0.25, 0.8):
				if between(moist, 0, 0.4) and between(temp, 0.2, 0.6):
					tilemap.set_cellv(pos, 0)
				
				if between(moist, 0.4, 0.9) and temp > 0.6:
					tilemap.set_cellv(pos, 1)
				
				elif temp > 0.7 and moist < 0.4:
					tilemap.set_cellv(pos, 6)
#				else:
#					tilemap.set_cellv(pos, 5)
#			else:
#				tilemap.set_cellv(pos, 5)

func between(val, start, end):
	if val >= start and val < end:
		return true

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
