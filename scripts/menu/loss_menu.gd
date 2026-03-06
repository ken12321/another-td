extends Node2D

@onready var menu_button = $MenuButton
@onready var retry_button = $RetryButton
@onready var round_label = $RoundLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retry_button.pressed.connect(_load_play_game)
	menu_button.pressed.connect(_load_menu)
	round_label.text = "you got to round %d" % PlayerStats.current_wave

func _load_play_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _load_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
