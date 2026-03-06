extends Control

@onready var resume_button = $ResumeButton
@onready var quit_button = $QuitButton

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled() #prevent event from reaching other nodes
		_on_resume_pressed()
