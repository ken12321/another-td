extends Node2D
@onready var wave_manager = $WaveManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_manager.start_wave()
