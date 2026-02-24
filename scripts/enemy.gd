extends CharacterBody2D

var target: Node2D

const SPEED = 100

func _set_target(t: Node2D) -> void:
	target = t


func _ready() -> void:
	add_to_group("enemies")
	var results = get_tree().get_nodes_in_group("track_nodes").filter(func(x): return x.track_position == 1)
	target = results[0] if results.size() > 0 else null
	

func _physics_process(_delta: float) -> void:
	if (target):
		look_at(target.global_position)
		if position.distance_to(target.global_position) > 0:
			global_position = global_position.move_toward(target.global_position, SPEED * _delta)
		else:

			if (!target.is_end):
				target = _get_next_node()
			else:
				print("last")


func _get_next_node() -> Node2D:
	var current_position = target.track_position
	var track_nodes = get_tree().get_nodes_in_group("track_nodes")
	
	for node in track_nodes:
		if node.track_position == current_position + 1:
			return node
			
	return null
