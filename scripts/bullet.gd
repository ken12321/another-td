extends Node2D
class_name Bullet

const MAX_RANGE : float = 1000 # Distance before bullet frees
var _distance_travelled: float = 0

@export var splash: bool #for now...

var direction: Vector2
var speed: float
var damage: float

const Explosion = preload("res://scenes/towers/explosion.tscn")


func _process(delta: float) -> void:
	var movement = direction * speed * delta
	global_position += movement
	
	_distance_travelled += movement.length()
	if (_distance_travelled > MAX_RANGE):
		queue_free()

func _on_area_2d_body_entered(body: Node) -> void:
	if (body is Enemy):
		body.take_damage(damage)
		if (splash):
			var explosion = Explosion.instantiate()
			explosion.damage = damage
			explosion.global_position = global_position
			get_tree().current_scene.add_child(explosion)
		queue_free()
