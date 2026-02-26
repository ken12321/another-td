extends Node2D
class_name TrackNode

@export var track_position: int
@export var is_end: bool

var track_nodes: Array[Node]

func _ready() -> void:
	track_nodes = get_tree().get_root().get_node("Game/Track").get_children()
	add_to_group("track_nodes")

func get_previous_node() -> TrackNode:
	var previous_node
	if (track_position > 0):
		return track_nodes[track_position - 1]
	else:
		return null
