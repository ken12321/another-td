extends CharacterBody2D
class_name Enemy

signal died

# Attacks are only relevant when enemies reach the Base
@export var data: EnemyData
#@export var attack_speed: float = 1
#@export var attack_damage: int = 10
var _attack_timer: float = 0.0

#@export var max_health: float = 1
#@export var reward: int = 10

@onready var sprite := $AnimatedSprite2D

var track_nodes: Array[Node]

var target: TrackNode
var distance_to_target: float
var health: float

#const SPEED = 100
const REACH_THRESHOLD = 5.0

func setup(nodes: Array[Node]) -> void:
	health = data.max_health
	
	track_nodes = nodes.duplicate()
	track_nodes.sort_custom(func(a, b): return a.track_position < b.track_position)
	target = track_nodes[0] if track_nodes.size() > 0 else null

func take_damage(damage: float) -> void:
	health -= damage
	if (health <= 0):
		die()

func die() -> void:
	died.emit()
	PlayerStats.add_credits(data.reward)
	queue_free()

func get_track_progress() -> float:
	if (!target):
		return 0
	
	var node_distance = target.get_previous_node().global_position.distance_to(target.global_position)
	var remaining_distance = position.distance_to(target.global_position)
	var progress = 1.0 - (remaining_distance / node_distance)
	
	return target.track_position + progress

func _ready() -> void:
	#health = data.max_health
	add_to_group("enemies")

func _physics_process(_delta: float) -> void:
	if (!target):
		return

	var direction = (target.global_position - global_position).normalized()
	_update_animation(direction)

	if (position.distance_to(target.global_position) > REACH_THRESHOLD):
		global_position = global_position.move_toward(target.global_position, data.speed * _delta)
	else:
		if (!target.is_end):
			target = _get_next_node()
		else:
			_attack_timer += _delta
			if (_attack_timer >= 1.0 / data.attack_speed):
				_attack_timer = 0.0
				PlayerStats.damage_base(data.damage)
				print(PlayerStats.base_health)

func _update_animation(direction: Vector2) -> void:
	var angle = direction.angle()
	
	if angle > -PI/2 and angle <= 0:
		sprite.play("walk_northeast")
	elif angle > 0 and angle <= PI/2:
		sprite.play("walk_southeast")
	elif angle > PI/2 and angle <= PI:
		sprite.play("walk_southwest")
	else:
		sprite.play("walk_northwest")

func _set_target(t: Node2D) -> void:
	target = t

func _get_next_node() -> Node2D:
	var current_position = target.track_position
	
	for node in track_nodes:
		if (node.track_position == current_position + 1):
			return node
			
	return null
