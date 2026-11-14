extends Node2D

const GUN_PLAYER_SCENE = preload("res://player.tscn")

@export var enemy_scene: PackedScene = preload("res://enemy.tscn")
func spawn_player(spawn_position: Vector2) -> void:
	var player = GUN_PLAYER_SCENE.instantiate()
	add_child(player)
	player.global_position = spawn_position

func _ready() -> void:
	spawn_player(Vector2(500,500))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	print('spawning')
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(randf_range(300, 1920), randf_range(0, 1080))
	add_child(enemy)


func _on_button_pressed() -> void:
	get_tree().quit()
