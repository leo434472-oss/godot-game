extends Node2D

const GUN_PLAYER_SCENE: PackedScene = preload("res://player.tscn")
var kill_count: int = 0
@onready var kill_label: Label = $UI/KillCount
@onready var countdown: Label = $UI/Countdown
@onready var countdown_time: Timer = $UI/Timer2
const enemy_normal_scene: PackedScene = preload("res://enemy_normal.tscn")
const enemy_fast_scene: PackedScene = preload("res://enemy_fast.tscn")
const enemy_more_HP_scene: PackedScene = preload("res://enemy_more_HP.tscn")
@onready var damage_label: Label = $UI/Stats/DamageSt
@onready var health_label: Label = $UI/Stats/HealthSt
@onready var speed_label: Label = $UI/Stats/SpeedSt

func update_upgrade_price():
	pass

func update_ui() -> void:
	damage_label.text = "Damage: " + str(Stats.damage)
	health_label.text = "Max Health: " + str(Stats.max_health)
	speed_label.text = "Speed: " + str(Stats.speed)

func spawn_player(spawn_position: Vector2) -> void:
	var player = GUN_PLAYER_SCENE.instantiate()
	add_child(player)
	player.global_position = spawn_position

func _ready() -> void:
	update_ui()
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

func _killcount():
	kill_count += 1
	kill_label.text = "Kills: " + str(kill_count)
	
func _on_button_pressed() -> void:
	get_tree().quit()
