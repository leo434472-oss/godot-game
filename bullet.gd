extends Area2D

@export var speed: float = 800
@export var damage : int 

func _ready() -> void:
		damage = Stats.damage

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage") and not is_in_group("Player"):
		body.take_damage(damage)
		queue_free()
