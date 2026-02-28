extends Control

@export var basic_tower_data: TowerData
@onready var basic_tower_button := $BasicTower
@onready var credits_label := $CreditsLabel
@onready var wave_label := $WaveLabel


# Game scene
@export var container: Node2D
@export var tile_map : TileMapLayer
@export var track: Node

var occupied_tiles: Dictionary = {}
var blocked_tiles: Dictionary = {}

var build_mode : bool = false
var placing_tower_data : TowerData
var ghost: Tower

func _ready() -> void:
	basic_tower_button.pressed.connect(_buy_basic_tower)
	
	credits_label.text = "Credits: %d" % PlayerStats.credits
	wave_label.text = "Wave: %d" % PlayerStats.current_wave
	PlayerStats.credits_changed.connect(_on_credits_changed)
	PlayerStats.wave_changed.connect(_on_wave_changed)

func _process(_delta: float) -> void:
	if ghost:
		var snapped_position = _get_snapped_position(get_global_mouse_position())
		ghost.global_position = snapped_position

# For isometric grid snapping
func _get_snapped_position(world_position: Vector2) -> Vector2:
	var tile_coords = tile_map.local_to_map(tile_map.to_local(world_position))
	return tile_map.to_global(tile_map.map_to_local(tile_coords))

func _on_credits_changed(new_amount: int) -> void:
	credits_label.text = "Credits: %d" % new_amount

func _on_wave_changed(new_wave: int) -> void:
	wave_label.text = "Wave: %d" % new_wave

func _buy_basic_tower() -> void:
	build_mode = true
	placing_tower_data = basic_tower_data
	_create_ghost()

func _can_place(tile_coords: Vector2i) -> bool:
	for tile in _get_tower_tiles(tile_coords):
		if occupied_tiles.has(tile) || blocked_tiles.has(tile):
			return false
	
	return true

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_LEFT && !event.pressed && build_mode):
			_place_tower(get_global_mouse_position())
			build_mode = false
		if (event.button_index == MOUSE_BUTTON_RIGHT && !event.pressed):
			var coord = tile_map.local_to_map(tile_map.to_local(get_global_mouse_position()))
			print(coord)
			tile_map.set_cell(coord, 2, Vector2i(0,0))
			

func _place_tower(world_position: Vector2) -> void:
	var tile_coords = tile_map.local_to_map(tile_map.to_local(world_position))

	if (!_can_place(tile_coords)):
		print("invalid placement") #todo: make red or some shi
		_clear_ghost()
		return

	if (!PlayerStats.spend_credits(placing_tower_data.cost)):
		print("not enough credits") # todo: do something here
		_clear_ghost()
		return
	
	for tile in _get_tower_tiles(tile_coords):
		occupied_tiles[tile] = true

	var tower_scene: Tower = placing_tower_data.tower_scene.instantiate()
	var snapped_position = _get_snapped_position(world_position)
	container.add_child(tower_scene)
	tower_scene.global_position = snapped_position
	tower_scene.data = placing_tower_data.duplicate(true)
	tower_scene.setup()
	_clear_ghost()

func _get_tower_tiles(origin: Vector2i) -> Array[Vector2i]: #todo make this more functional for larger/smaller towers
	var right = tile_map.get_neighbor_cell(origin, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE)
	var left = tile_map.get_neighbor_cell(origin, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE)
	var bottom = tile_map.get_neighbor_cell(left, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE)
	return [origin, left, right, bottom]

func _create_ghost() -> void:
	if (ghost):
		ghost.queue_free()
	ghost = placing_tower_data.tower_scene.instantiate() as Tower
	ghost.modulate.a = 0.5 # set alpha value
	ghost.set_process(false)
	container.add_child(ghost)

func _clear_ghost() -> void:
	if (ghost):
		ghost.queue_free()
		ghost = null
