extends Node2D

@onready var health_bar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerStats.base_damaged.connect(_update_health_bar)

func _update_health_bar() -> void:
	$HealthBar.value = PlayerStats.base_health
