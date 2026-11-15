extends Node2D

const GUN_PLAYER_SCENE: PackedScene = preload("res://player.tscn")
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
	coins.text = "Coins: " + str(Stats.total_kills)
	kill_label.text = "Kills: " + str(Stats.kill_count)

func upgrade_damage():
	if Stats.total_kills >= DamageUpPrice:
		Stats.total_kills -= DamageUpPrice
		Stats.damage += 20
		DamageUpPrice += 1
		update_ui()
		update_upgrade_price()
	else:
		damage_price.text = 'INSUFFICIENT!'
		await get_tree().create_timer(0.5).timeout
		update_upgrade_price()
		
func upgrade_health():
	if Stats.total_kills >= HealthUpPrice:
		Stats.total_kills -= HealthUpPrice
		Stats.max_health += 20
		HealthUpPrice += 1
		update_ui()
		update_upgrade_price()
	else:
		health_price.text = 'INSUFFICIENT!'
		await get_tree().create_timer(0.5).timeout
		update_upgrade_price()
		
func upgrade_speed():
	if Stats.total_kills >= SpeedUpPrice:
		Stats.total_kills -= SpeedUpPrice
		Stats.speed += 20
		SpeedUpPrice += 1
		update_ui()
		update_upgrade_price()
	else:
		speed_price.text = 'INSUFFICIENT!'
		await get_tree().create_timer(0.5).timeout
		update_upgrade_price()

func spawn_player(spawn_position: Vector2) -> void:
	var player = GUN_PLAYER_SCENE.instantiate()
	add_child(player)
	player.global_position
