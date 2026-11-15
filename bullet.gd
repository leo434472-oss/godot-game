extends Area2D

@export var speed:float = 400
@export var damage : int = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_body_entered(body) -> void:
	if body.has_method('take_damage') and body != 'Player':
		body.take_damage(damage)
		queue_free()
