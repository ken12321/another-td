extends CharacterBody2D
class_name Enemy

@export var max_health: float = 1
@export var reward: int = 10

var track_nodes: Array[Node]

var target: TrackNode
var distance_to_target: float
var health: float

const SPEED = 100
const REACH_THRESHOLD = 5.0

func setup(nodes: Array[Node]) -> void:
	track_nodes = nodes.duplicate()
	track_nodes.sort_custom(func(a, b): return a.track_position < b.track_position)
	target = track_nodes[0] if track_nodes.size() > 0 else null

func take_damage(damage: float) -> void:
	health -= damage
	if (health <= 0):
		die()

func die() -> void:
	PlayerStats.add_credits(reward)
	queue_free()

func get_track_progress() -> float:
	if (!target):
		return 0
	
	var node_distance = target.get_previous_node().global_position.distance_to(target.global_position)
	var remaining_distance = position.distance_to(target.global_position)
	var progress = 1.0 - (remaining_distance / node_distance)
	
	return target.track_position + progress

func _ready() -> void:
	health = max_health
	add_to_group("enemies")

func _physics_process(_delta: float) -> void:
	if (!target):
		return

	look_at(target.global_position)
	if (position.distance_to(target.global_position) > REACH_THRESHOLD):
		global_position = global_position.move_toward(target.global_position, SPEED * _delta)
	else:
		if (!target.is_end):
			target = _get_next_node()
		#else:
			#lost life logic

func _set_target(t: Node2D) -> void:
	target = t

func _get_next_node() -> Node2D:
	var current_position = target.track_position
	
	for node in track_nodes:
		if (node.track_position == current_position + 1):
			return node
			
	return null
