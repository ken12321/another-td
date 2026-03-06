extends Node2D
@onready var wave_manager = $WaveManager
@onready var pause_menu := $PauseMenu

const round_bonus = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerStats.base_destroyed.connect(_on_base_destroyed)
	
	wave_manager.wave_completed.connect(_on_wave_completed)
	wave_manager.start_wave()

func _on_wave_completed() -> void:
	PlayerStats.add_credits(round_bonus)
	PlayerStats.current_wave += 1
	await get_tree().create_timer(5.0).timeout  # breathing room between waves
	wave_manager.start_wave()

func _on_base_destroyed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/loss_menu.tscn")

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_cancel") && !pause_menu.visible):  # Escape key by default
		_toggle_pause()

func _toggle_pause() -> void:
	var paused = !get_tree().paused
	get_tree().paused = paused
	pause_menu.visible = paused
