extends CharacterBody2D
var killcount : int = 0
var enemy_buff_speed = 25
var enemy_buff_health :int= 300
var enemy_buff_damage :int = 20
func _ready() -> void:
	pass
func take_damage(amount: int) -> void:
	enemy_buff_health -= amount
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if enemy_buff_health <= 0:
		die()
		
func die():
	Events.died.emit(global_position)
	queue_free()
	
	
func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemy_buff_speed
	move_and_slide()

func _on_hitbox_buff_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		if body.has_method('take_damage'):
			await get_tree().create_timer(.3).timeout
			body.take_damage(enemy_buff_damage)
