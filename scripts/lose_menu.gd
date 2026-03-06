extends Node2D

@onready var menu_button = $MenuButton
@onready var retry_button = $RetryButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retry_button.pressed.connect(_load_play_game)
	menu_button.pressed.connect(_load_menu)

func _load_play_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _load_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
