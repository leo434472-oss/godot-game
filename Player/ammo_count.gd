extends Label
@export var offset: Vector2 = Vector2(50, 50)
@onready var player: Node2D = get_parent()

func _process(_delta: float) -> void:
	if player:
		global_position = player.global_position + offset
