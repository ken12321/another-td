extends Node2D
class_name Tower

@export var data: TowerData

var target: Enemy = null
var enemies_in_range: Array[Enemy] = []

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
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	target = _get_furthest_enemy()
	
	if (!target):
		return
	
	_spawn_bullet()

func _on_enemy_entered(body: Node2D) -> void:
	if (body is Enemy):
		enemies_in_range.append(body)

func _on_enemy_exited(body: Node2D) -> void:
	if (body is Enemy):
		enemies_in_range.erase(body)

func _get_furthest_enemy() -> Enemy:
	var furthest: Enemy = null
	var highest_progress = -1.0
	
	for enemy in enemies_in_range:
		if (!is_instance_valid(enemy)):
			continue
		var progress = enemy.get_track_progress()
		if (progress > highest_progress):
			highest_progress = progress
			furthest = enemy
	
	return furthest

func _spawn_bullet() -> void:
	if data.bullet_scene == null:
		return

	var bullet := data.bullet_scene.instantiate()
	bullet.global_position = global_position

	bullet.direction = (target.global_position - global_position).normalized()
	bullet.speed = 1000
	bullet.damage = data.damage

	get_tree().current_scene.add_child(bullet)
