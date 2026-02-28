extends Node
class_name WaveManager

signal wave_completed

@export var waves: Array[WaveData]
@export var spawn_point: Node2D
@export var enemy_container: Node
@export var track: Node

var current_wave_index: int = 0
var enemies_remaining: int = 0
var enemies_in_queue: int = 0

func start_wave() -> void:
	if (current_wave_index >= waves.size()):
		print("all waves complete")
		# todo win condition
		return

	var wave = waves[current_wave_index]
	_spawn_wave(wave)

func _spawn_wave(wave_data: WaveData) -> void:
	enemies_in_queue = 0
	for entry in wave_data.waves:
		enemies_in_queue += entry.count

	for entry in wave_data.waves:
		await _spawn_entry(entry)
	current_wave_index += 1

func _spawn_entry(entry: WaveEntry) -> void:
	for enemy in entry.count:
		_spawn_enemy(entry.enemy_scene)
		await get_tree().create_timer(entry.spawn_interval).timeout

func _spawn_enemy(enemy_scene: PackedScene) -> void:
	enemies_remaining += 1
	enemies_in_queue -= 1
	var enemy := enemy_scene.instantiate() as Enemy
	enemy_container.add_child(enemy)
	enemy.global_position = spawn_point.global_position
	enemy.died.connect(_on_enemy_died)
	enemy.setup(track.get_children())

func _on_enemy_died() -> void:
	enemies_remaining -= 1
	if (enemies_remaining <= 0 && enemies_in_queue <= 0):
		wave_completed.emit()
