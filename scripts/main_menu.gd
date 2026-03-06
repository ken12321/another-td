extends Node2D

@onready var play_button = $PlayButton
@onready var exit_button = $ExitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.pressed.connect(_load_play_game)
	exit_button.pressed.connect(_exit_game)

func _load_play_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _exit_game() -> void:
	get_tree().quit()
