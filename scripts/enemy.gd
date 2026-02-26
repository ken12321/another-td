extends CharacterBody2D
class_name Enemy

#signal died(reward: int)

@export var max_health: float = 1
#@export var reward: int = 10

var track_nodes: Array[Node]
var target: Node2D
var health: float

const SPEED = 100

func _set_target(t: Node2D) -> void:
	target = t

func _ready() -> void:
	health = max_health
	add_to_group("enemies")

	track_nodes = get_tree().get_root().get_node("Game/Track").get_children()
	var first_track = track_nodes.filter(func(x): return x.track_position == 1)
	target = first_track[0] if first_track.size() > 0 else null

func _physics_process(_delta: float) -> void:
	if (target):
		look_at(target.global_position)
		if (position.distance_to(target.global_position) > 0):
			global_position = global_position.move_toward(target.global_position, SPEED * _delta)
		else:

			if (!target.is_end):
				target = _get_next_node()
			#else:
				#lost life logic

func take_damage(damage: float) -> void:
	health -= damage
	if (health <= 0):
		die()

func die() -> void:
	#died.emit(reward)
	queue_free()

func _get_next_node() -> Node2D:
	var current_position = target.track_position
	track_nodes
	
	for node in track_nodes:
		if (node.track_position == current_position + 1):
			return node
			
	return null
