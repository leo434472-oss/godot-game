extends Node2D

const GUN_PLAYER_SCENE: PackedScene = preload("res://player.tscn")
var kill_count: int = 0
var total_kills = 0
@onready var coins: Label = $UI/Coins
@onready var kill_label: Label = $UI/KillCount
@onready var countdown: Label = $UI/Countdown
@onready var countdown_time: Timer = $UI/Timer2
const enemy_normal_scene: PackedScene = preload("res://enemy_normal.tscn")
const enemy_fast_scene: PackedScene = preload("res://enemy_fast.tscn")
const enemy_more_HP_scene: PackedScene = preload("res://enemy_more_HP.tscn")
const buff_enemy_scene: PackedScene = preload("res://buff_enemy.tscn")
@onready var damage_label: Label = $UI/Stats/DamageSt
@onready var health_label: Label = $UI/Stats/HealthSt
@onready var speed_label: Label = $UI/Stats/SpeedSt

var DamageUpPrice = 1
var HealthUpPrice = 1
var SpeedUpPrice = 1
@onready var damage_price: Button = $UI/UpgradeButtons/DamageUp
@onready var health_price: Button = $UI/UpgradeButtons/HealthUp
@onready var speed_price: Button = $UI/UpgradeButtons/SpeedUp

func update_upgrade_price():
	health_price.text = "Upgrade Health (%d kills)" % HealthUpPrice
	damage_price.text = "Upgrade Damage (%d kills)" % DamageUpPrice
	speed_price.text = "Upgrade Speed (%d kills)" % SpeedUpPrice

func update_ui() -> void:
	damage_label.text = "Damage: " + str(Stats.damage)
	health_label.text = "Max Health: " + str(Stats.max_health)
	speed_label.text = "Speed: " + str(Stats.speed)
	coins.text = "Coins: " + str(total_kills)

func upgrade_damage():
	if total_kills >= DamageUpPrice:
		total_kills -= DamageUpPrice
		Stats.damage += 20
		DamageUpPrice += 1 # Scale price up so it gets harder next time!
		update_ui()
		update_upgrade_price()
	else:
		damage_price.text = 'INSUFFICIENT!'
		await get_tree().create_timer(0.5).timeout
		update_upgrade_price()
		
func upgrade_health():
	if total_kills >= HealthUpPrice:
		total_kills -= HealthUpPrice
		Stats.max_health += 20
		HealthUpPrice += 1 # Scale price up
		update_ui()
		update_upgrade_price()
	else:
		health_price.text = 'INSUFFICIENT!'
		await get_tree().create_timer(0.5).timeout
		update_upgrade_price()
		
func upgrade_speed():
	if total_kills >= SpeedUpPrice:
		total_kills -= SpeedUpPrice
		Stats.speed += 20
		SpeedUpPrice += 1 # Scale price up
		update_ui()
		update_upgrade_price()
	else:
		speed_price.text = 'INSUFFICIENT!'
		await get_tree().create_timer(0.5).timeout
		update_upgrade_price()

func spawn_player(spawn_position: Vector2) -> void:
	var player = GUN_PLAYER_SCENE.instantiate()
	add_child(player)
	player.global_position = spawn_position

func _ready() -> void:
	update_ui()
	update_upgrade_price()

	kill_label.text = "Kills: 0"
	Events.died.connect(_killcount)
	spawn_player(Vector2(500, 500))
	if countdown_time:
		countdown_time.start()

func _countdown() -> String:
	var seconds: int = int(ceil(countdown_time.time_left))
	return str(seconds)

func _process(_delta: float) -> void:
	if countdown and countdown_time:
		countdown.text = _countdown()

func _on_timer_2_timeout() -> void:
	countdown.hide()
	$Timer.start()
	_on_timer_timeout()
	
func _on_timer_timeout() -> void:
	var enemy_normal = enemy_normal_scene.instantiate()
	enemy_normal.position = Vector2(randf_range(1700, 1800), randf_range(0, 1080))
	add_child(enemy_normal)
	
	var enemy_fast = enemy_fast_scene.instantiate()
	enemy_fast.position = Vector2(randf_range(1700, 1800), randf_range(0, 1080))
	add_child(enemy_fast)
	
	var enemy_more_HP = enemy_more_HP_scene.instantiate()
	enemy_more_HP.position = Vector2(randf_range(1700, 1800), randf_range(0, 1080))
	add_child(enemy_more_HP)
	
	var buff_enemy = buff_enemy_scene.instantiate()
	buff_enemy.position = Vector2(randf_range(1700, 1800), randf_range(0, 1080))
	add_child(buff_enemy)

func _killcount():
	kill_count += 1
	total_kills += 1
	update_ui()
	kill_label.text = "Kills: " + str(kill_count)
	
func _on_button_pressed() -> void:
	get_tree().quit()

func _on_damage_up_pressed() -> void:
	upgrade_damage()

func _on_health_up_pressed() -> void:
	upgrade_health()

func _on_speed_up_pressed() -> void:
	upgrade_speed()
