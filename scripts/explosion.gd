extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("explode")
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	queue_free()
