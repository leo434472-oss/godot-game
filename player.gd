extends CharacterBody2D
@export var bullet_scene: PackedScene = preload("res://bullet.tscn")
@onready var muzzle: Marker2D = $Muzzle
var speed: float
var max_health: int
var player_health: int
func _ready() -> void:
	speed = Stats.speed
	max_health = Stats.max_health
	player_health = max_health

func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	move_and_slide()

func _process(delta):
	look_at(get_global_mouse_position())

func take_damage(amount):
	print('takingdamage')
	player_health -= amount
	print(player_health)
	if player_health<=0:
		_lose()
func _lose():
	get_tree().change_scene_to_file("res://game_over.tscn")
	get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.start(muzzle.global_position, global_rotation)
