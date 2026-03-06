extends Node2D

@export var damage: int

func _ready() -> void:
	$AnimatedSprite2D.play("explode")
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node) -> void:
	if (body is Enemy):
		body.take_damage(damage)
