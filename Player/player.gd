extends CharacterBody2D
var is_dead: bool = false
@export var bullet_scene : PackedScene 
@onready var muzzle: Marker2D = $Muzzle
@onready var ammoCount : Label = $"../HUD/UI/AmmoCount"
@onready var muzzleFlash : Sprite2D = $Muzzle/MuzzleFlash
var bullet_left : int = 15
var max_bullets : int = 15
var speed: float
var max_health: int
var player_health: int 
var is_reloading: bool = false 
@onready var camera: Camera2D = $Camera2D
var regen_rate : float = 1.5
func _ready() -> void:
	speed = Stats.speed
	max_health = Stats.max_health
	player_health = max_health
	update_ammo_display()

func _physics_process(_delta):
	Stats.player_health = player_health
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed 
	move_and_slide()

func _process(_delta):
	look_at(get_global_mouse_position())

func take_damage(amount):
	if is_dead:
		return
	camera.apply_shake(3.0)
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE

	
	player_health -= amount
	Events.tookDamage.emit(amount)
	if player_health <= 0:
		_lose()

func _lose():
	await get_tree().create_timer(.2).timeout
	get_tree().call_deferred("change_scene_to_file", "res://game_over_screen.tscn")
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
		showMuzzleFlash()
		camera.apply_shake(1.0)
		
		$Muzzle/ShootSound.play()
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.start(muzzle.global_position, global_rotation)
	else:
		reload()

func reload() -> void:
	is_reloading = true
	ammoCount.text = 'reloading...'
	$Muzzle/ReloadSound.play()
	await get_tree().create_timer(2).timeout
	
	bullet_left = max_bullets
	update_ammo_display()
	is_reloading = false 

func update_ammo_display() -> void:
	ammoCount.text = "%d/%d" % [bullet_left, max_bullets]

func showMuzzleFlash():
	muzzleFlash.show()
	await get_tree().create_timer(.1).timeout
	muzzleFlash.hide()


func _on_regen_timer_timeout() -> void:
	if player_health < Stats.max_health:
		player_health += 5
