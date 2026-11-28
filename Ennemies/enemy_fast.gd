extends CharacterBody2D
var killcount : int = 0
var enemy_fast_speed = 40
var enemy_fast_health :int= 100
var enemy_normal_damage :int = 10

func _ready() -> void:
	pass

func take_damage(amount: int) -> void:
	enemy_fast_health -= amount
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if enemy_fast_health <= 0:
		die()
		
func die():
	
	Events.died.emit(global_position)
	queue_free()
	
	
func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * enemy_fast_speed
	move_and_slide()


func _on_hitbox_fast_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		if body.has_method('take_damage'):
			await get_tree().create_timer(.3).timeout
			body.take_damage(enemy_normal_damage)
