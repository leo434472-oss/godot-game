extends CharacterBody2D

const enemy_normal_speed = 300.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemy_normal_speed
	move_and_slide()
