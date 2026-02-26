extends Node2D
class_name Tower

@export var data: TowerData

var target: Enemy = null
var _timer: Timer

# Called when the node enters the scene tree for the first time.
func setup() -> void:
	$Range/CollisionShape2D.shape.radius = data.range

	_timer = Timer.new()
	_timer.wait_time = 1.0 / data.fire_rate
	_timer.timeout.connect(_shoot)
	add_child(_timer)
	_timer.start()
	
	$Range.body_entered.connect(_on_enemy_entered)
	$Range.body_exited.connect(_on_enemy_exited)

func _physics_process(_delta: float) -> void:
	if(target):
		look_at(target.global_position)

func _shoot() -> void:
	if (target == null || !is_instance_valid(target)):
		target = null
		return
	_spawn_bullet()

func _on_enemy_entered(body: Node2D) -> void:
	if (body is Enemy && target == null):
		target = body

func _on_enemy_exited(body: Node2D) -> void:
	if (body == target):
		target = null

func _spawn_bullet() -> void:
	if data.bullet_scene == null:
		return

	var bullet := data.bullet_scene.instantiate()
	bullet.global_position = global_position

	bullet.direction = (target.global_position - global_position).normalized()
	bullet.speed = 1000
	bullet.damage = data.damage

	get_tree().current_scene.add_child(bullet)
