extends Control

@export var basic_tower_data: TowerData
@onready var basic_tower_button := $BasicTower

# Game scene
@export var container: Node2D

var build_mode : bool = false
var placing_tower_data : TowerData
var ghost: Tower

func _ready() -> void:
	basic_tower_button.pressed.connect(_buy_basic_tower)

func _process(_delta: float) -> void:
	if ghost:
		ghost.global_position = get_global_mouse_position()

func _buy_basic_tower() -> void:
	build_mode = true
	placing_tower_data = basic_tower_data
	_create_ghost()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and build_mode:
			_place_tower(get_global_mouse_position())
			build_mode = false

func _place_tower(world_position: Vector2) -> void:
	var tower_scene: Tower = placing_tower_data.packed_scene.instantiate()
	container.add_child(tower_scene)
	tower_scene.global_position = world_position
	tower_scene.data = placing_tower_data.duplicate()
	_clear_ghost()

func _create_ghost() -> void:
	if ghost:
		ghost.queue_free()
	ghost = placing_tower_data.packed_scene.instantiate() as Tower
	ghost.modulate.a = 0.5 # set alpha value
	ghost.set_process(false)
	container.add_child(ghost)

func _clear_ghost() -> void:
	if ghost:
		ghost.queue_free()
		ghost = null
