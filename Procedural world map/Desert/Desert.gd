extends Node2D

enum Cell {OBSTACLE, GROUND, OUTER}

export var inner_size := Vector2(320, 180)
export var perimeter_size := Vector2(1, 1)
export(float, 0 , 1) var ground_probability := 0.1

# Public variables
onready var size := inner_size + 2 * perimeter_size

# Private variables
onready var _tile_map : TileMap = $TileMap
var _rng := RandomNumberGenerator.new()

func generate() -> void:
	generate_perimeter()
	generate_inner()


func generate_perimeter() -> void:
	# Fills the outer edges of the map with the border tiles.
	# Randomly selects from the tiles marked as `Cell.OUTER` using the funciton `_pick_random_texture`.
	# The two nested loops below fill the outer columns and outer row
	# of the map, respectively.
	for x in [0, size.x - 1]:
		for y in range(0, size.y):
			_tile_map.set_cell(x, y, _pick_random_texture(Cell.OUTER))
	for x in range(1, size.x - 1):
		for y in [0, size.y - 1]:
			_tile_map.set_cell(x, y, _pick_random_texture(Cell.OUTER))


func generate_inner() -> void:
	# Fills the inside of the map the inner tiles from the remaining types: `Cell.GROUND` and `Cell.OBSTACLE` using the
	# `get_random_tile` function that takes the probability for `Cell.GROUND` tiles to have some more control
	# over what types of tiles we'll be placing.
	for x in range(1, size.x - 1):
		for y in range(1, size.y - 1):
			var cell := get_random_tile(ground_probability)
			_tile_map.set_cell(x, y, cell)


func get_random_tile(probability: float) -> int:
	# Randomly picks a tile id between `Cell.GROUND` and `Cell.OBSTACLE` types given the ground probability.
	# Returns the id of the cell in the TileSet resource.
	return _pick_random_texture(Cell.GROUND) if _rng.randf() < probability else _pick_random_texture(Cell.OBSTACLE)


func _pick_random_texture(cell_type: int) -> int:
	# Randomly picks a tile based on the three types: `Cell.OUTER`, `Cell.GROUND` & `Cell.OBSTACLE`.
	# Returns the id of the cell in the TileSet resource.
	var interval := Vector2()
	if cell_type == Cell.OUTER:
		interval = Vector2(0, 9)
	elif cell_type == Cell.GROUND:
		interval = Vector2(10, 14)
	elif cell_type == Cell.OBSTACLE:
		interval = Vector2(15, 27)
	return _rng.randi_range(interval.x, interval.y)


func _ready() -> void:
	if PlayerStats.from_scene != null:
		$"%Player".set_position(get_node(PlayerStats.from_scene+"Pos").position)
	_rng.randomize()
	generate()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		generate()
