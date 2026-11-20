extends CharacterBody2D

@export var bullet_scene : PackedScene 
@onready var muzzle: Marker2D = $Muzzle
@onready var ammoCount : Label = $AmmoCount

var bullet_left : int = 12
var max_bullets : int = 12
var speed: float
var max_health: int
var player_health: int
var is_reloading: bool = false 

func _ready() -> void:
	speed = Stats.speed
	max_health = Stats.max_health
	player_health = max_health
	update_ammo_display()

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
	if player_health <= 0:
		_lose()

func _lose():
	$DeathSound.play()
	await get_tree().create_timer(.2).timeout
	get_tree().change_scene_to_file("res://game_over_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if is_reloading:
		return 

	if event.is_action_pressed("shoot"):
		shoot()
	elif event.is_action_pressed("reload"):
		if bullet_left < max_bullets:
			reload()

func shoot() -> void:
	if bullet_left > 0:
		bullet_left -= 1 
		update_ammo_display()
		
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.start(muzzle.global_position, global_rotation)
	else:
		reload()

func reload() -> void:
	is_reloading = true
	ammoCount.text = 'reloading...'
	
	await get_tree().create_timer(2).timeout
	
	bullet_left = max_bullets
	update_ammo_display()
	is_reloading = false 

func update_ammo_display() -> void:
	ammoCount.text = "%d/%d" % [bullet_left, max_bullets]
