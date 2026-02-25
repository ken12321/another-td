extends Node
@export var track_position: int
@export var is_end: bool


func _ready() -> void:
	add_to_group("track_nodes")
