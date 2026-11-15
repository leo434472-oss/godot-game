extends CharacterBody2D

var enemy_normal_speed = 300.0
var enemy_normal_health :int= 100
var enemy_normal_damage :int = 15

func _ready() -> void:
	pass
func _take_damage(amount):
	enemy_normal_health -= amount
	print(enemy_normal_health)
	if enemy_normal_health <= 0:
		_die()
		
func _die():
	queue_free()
	
	
func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemy_normal_speed
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("AREA DÉTECTÉE : ", area.name)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print('touching')
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			print('attacking')
			body.take_damage(enemy_normal_damage)
