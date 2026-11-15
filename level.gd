extends Node2D

const GUN_PLAYER_SCENE: PackedScene = preload("res://player.tscn")
var kill_count: int = 0
@onready var kill_label: Label = $KillCount
@onready var countdown: Label = $Countdown
@onready var countdown_time: Timer = $Timer2
@export var enemy_scene: PackedScene = preload("res://enemy.tscn")

func spawn_player(spawn_position: Vector2) -> void:
	var player = GUN_PLAYER_SCENE.instantiate()
	add_child(player)
	player.global_position = spawn_position

func _ready() -> void:
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
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(randf_range(1700, 1800), randf_range(0, 1080))
	add_child(enemy)

func _killcount():
	kill_count += 1
	kill_label.text = "Kills: " + str(kill_count)
	
func _on_button_pressed() -> void:
	get_tree().quit()
