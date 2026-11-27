
extends Node2D

const GUN_PLAYER_SCENE: PackedScene = preload("res://Player/player.tscn")

var kill_count: int = 0
var total_kills: int = 0

@onready var coins: Label = $HUD/UI/Stats/Coins
@onready var kill_label: Label = $HUD/UI/KillCount
@onready var countdown: Label = $HUD/UI/StartCountdown
@onready var countdown_time: Timer = $HUD/UI/Timer2

const enemy_normal_scene: PackedScene = preload("res://Ennemies/enemy_normal.tscn")
const enemy_fast_scene: PackedScene = preload("res://Ennemies/enemy_fast.tscn")
const enemy_buff_scene: PackedScene = preload("res://Ennemies/enemy_buff.tscn")

@onready var damage_label: Label = $HUD/UI/Stats/DamageSt
@onready var health_label: Label = $HUD/UI/Stats/HealthSt
@onready var speed_label: Label = $HUD/UI/Stats/SpeedSt

var DamageUpPrice: int = 1
var HealthUpPrice: int = 1
var SpeedUpPrice: int = 1

@onready var damage_price: Button = $HUD/UI/UpgradeButtons/DamageUp
@onready var health_price: Button = $HUD/UI/UpgradeButtons/HealthUp
@onready var speed_price: Button = $HUD/UI/UpgradeButtons/SpeedUp

@onready var currentHealth: Label = $HUD/UI/Stats/CurrentHealth

@onready var DeathSound: AudioStreamPlayer2D = $EnemyDeathSound
@onready var HealthBar: ProgressBar = $HUD/UI/HealthBar

var waves: int = 0

var enemy_normal_to_spawn: int = 1
var enemy_fast_to_spawn: int = 1
var enemy_buff_to_spawn: int = 1

var enemies_alive: int = 0
var is_spawning_enemies: bool = false

@onready var WaveCount: Label = $HUD/UI/Stats/WaveCount
@onready var EnemiesAliveCount: Label = $HUD/UI/Stats/EnemiesAliveCount


func update_current_health():
	currentHealth.text = "Health: " + str(Stats.player_health)
	HealthBar.max_value = Stats.max_health
	HealthBar.value = Stats.player_health


func update_upgrade_price():
	health_price.text = "Upgrade Health (%d coins(s))" % HealthUpPrice
	damage_price.text = "Upgrade Damage (%d coins(s))" % DamageUpPrice
	speed_price.text = "Upgrade Speed (%d coins(s))" % SpeedUpPrice


func update_ui() -> void:
	damage_label.text = "Damage: " + str(Stats.damage)
	health_label.text = "Max Health: " + str(Stats.max_health)
	speed_label.text = "Speed: " + str(Stats.speed)
	coins.text = "Coins: " + str(total_kills)


func upgrade_damage():
	if total_kills >= DamageUpPrice:
		total_kills -= DamageUpPrice
		Stats.damage += 20
		DamageUpPrice += 1
		update_ui()
		update_upgrade_price()
	else:
		damage_price.text = "INSUFFICIENT!"
		await get_tree().create_timer(0.5).timeout
		update_upgrade_price()


func upgrade_health():
	if total_kills >= HealthUpPrice:
		total_kills -= HealthUpPrice
		Stats.max_health += 20
		HealthUpPrice += 1
		update_ui()
		update_upgrade_price()
	else:
		health_price.text = "INSUFFICIENT!"
		await get_tree().create_timer(0.5).timeout
		update_upgrade_price()


func upgrade_speed():
	if total_kills >= SpeedUpPrice:
		total_kills -= SpeedUpPrice
		Stats.speed += 20
		SpeedUpPrice += 1
		update_ui()
		update_upgrade_price()
	else:
		speed_price.text = "INSUFFICIENT!"
		await get_tree().create_timer(0.5).timeout
		update_upgrade_price()


func _ready() -> void:
	update_current_health()
	update_ui()
	update_upgrade_price()

	kill_label.text = "Kills: 0"

	Events.died.connect(_killcount)

	$Player.global_position = Vector2(575, 75)


func _countdown() -> String:
	var seconds: int = int(ceil(countdown_time.time_left))
	return str(seconds)


func _process(_delta: float) -> void:
	update_current_health()

	if countdown and countdown_time:
		countdown.text = _countdown()


func _on_timer_2_timeout() -> void:
	countdown.hide()
	$EnemySpawnTimer.start()
	new_wave()


func spawn_enemies():
	is_spawning_enemies = true

	for i in range(enemy_normal_to_spawn):
		var enemy_normal = enemy_normal_scene.instantiate()
		enemy_normal.position = Vector2(
			randf_range(500, 640),
			randf_range(0, 1080)
		)

		await get_tree().create_timer(2).timeout
		add_child(enemy_normal)
		enemies_alive += 1

	for j in range(enemy_fast_to_spawn):
		var enemy_fast = enemy_fast_scene.instantiate()
		enemy_fast.position = Vector2(
			randf_range(500, 640),
			randf_range(0, 1080)
		)

		await get_tree().create_timer(3).timeout
		add_child(enemy_fast)
		enemies_alive += 1

	for h in range(enemy_buff_to_spawn):
		var enemy_buff = enemy_buff_scene.instantiate()
		enemy_buff.position = Vector2(
			randf_range(500, 640),
			randf_range(0, 1080)
		)

		await get_tree().create_timer(5).timeout
		add_child(enemy_buff)
		enemies_alive += 1

	EnemiesAliveCount.text = "Enemies alive: " + str(enemies_alive)
	is_spawning_enemies = false

	if enemies_alive == 0:
		new_wave()


func update_enemies_to_spawn():
	enemy_normal_to_spawn += 1
	enemy_fast_to_spawn += 1
	enemy_buff_to_spawn += 1


func _on_enemy_died():
	if enemies_alive <= 0:
		return

	enemies_alive -= 1

	EnemiesAliveCount.text = "Enemies alive: " + str(enemies_alive)

	if enemies_alive == 0 and not is_spawning_enemies:
		new_wave()


func new_wave():
	waves += 1

	if waves > 1:
		update_enemies_to_spawn()

	WaveCount.text = "Wave number: " + str(waves)

	spawn_enemies()


func _killcount(death_pos: Vector2):
	kill_count += 1
	total_kills += 1

	update_ui()

	kill_label.text = "Kills: " + str(kill_count)

	DeathSound.global_position = death_pos
	DeathSound.play()

	_on_enemy_died()


func _on_button_pressed() -> void:
	get_tree().quit()


func _on_damage_up_pressed() -> void:
	upgrade_damage()


func _on_health_up_pressed() -> void:
	upgrade_health()


func _on_speed_up_pressed() -> void:
	upgrade_speed()
