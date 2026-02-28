extends Node2D
@onready var wave_manager = $WaveManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_manager.wave_completed.connect(_on_wave_completed)
	wave_manager.start_wave()

func _on_wave_completed() -> void:
	PlayerStats.current_wave += 1
	await get_tree().create_timer(5.0).timeout  # breathing room between waves
	wave_manager.start_wave()
