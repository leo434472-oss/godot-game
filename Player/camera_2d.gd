extends Camera2D

var shake_strength: float = 0.0
var shake_decay: float = 10.0 

func _process(delta: float) -> void:
	if shake_strength > 0.0:
		shake_strength = lerpf(shake_strength, 0.0, shake_decay * delta)
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		offset = Vector2.ZERO

func apply_shake(strength: float) -> void:
	shake_strength = maxf(shake_strength, strength)

func _ready() -> void:
	pass 
