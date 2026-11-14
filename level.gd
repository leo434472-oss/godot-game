extends Node2D

@export var enemy_scene: PackedScene = preload("res://enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(randf_range(1700, 1800), randf_range(0, 1080))
	add_child(enemy)


func _on_button_pressed() -> void:
	get_tree().quit()
