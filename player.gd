extends CharacterBody2D
var player_health : int = 200
@export var bullet_scene: PackedScene = preload("res://bullet.tscn")
@onready var muzzle: Marker2D = $Muzzle

func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * 400
	move_and_slide()

func _process(delta):
	look_at(get_global_mouse_position())

func take_damage(amount):
	player_health -= amount
	print(player_health)
	if player_health<=0:
		_lose()
func _lose():
	get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = muzzle.global_position
	bullet.global_rotation = global_rotation
