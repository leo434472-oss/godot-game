extends CharacterBody2D
var killcount : int = 0
var enemy_fast_speed = 1000
var enemy_normal_health :int= 100
var enemy_normal_damage :int = 15
func _ready() -> void:
	pass
func take_damage(amount: int) -> void:
	enemy_normal_health -= amount
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if enemy_normal_health <= 0:
		die()
		
func die():
	Events.died.emit()
	queue_free()
	
	
func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemy_fast_speed
	move_and_slide()



func _on_area_2d_body_entered(body: Node2D) -> void:
	print('touching')
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			print('attacking')
			body.take_damage(enemy_normal_damage)
