extends Area2D
var direction: Vector2 = Vector2.RIGHT
var hasbounced : bool = false
var bounces : int = 0
@onready var ray: RayCast2D = $RayCast2D
@export var bullet_speed: float = 800
@export var damage : int 

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(global_rotation)
	damage = Stats.damage
	await get_tree().create_timer(3.0).timeout
	queue_free()
	
func start(pos: Vector2, rot: float) -> void:
	global_position = pos
	global_rotation = rot
	direction = Vector2.RIGHT.rotated(rot)
	
func _physics_process(delta: float) -> void:
	if bounces > Stats.bounce_count:
		queue_free()
	if ray.is_colliding():
		var wall_normal: Vector2 = ray.get_collision_normal()
		direction = direction.bounce(wall_normal)
		rotation = direction.angle()
		ray.force_raycast_update()
		hasbounced = true
		bounces += 1
		$AudioStreamPlayer2D.play()
		
	position += direction * bullet_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		return
	if body.has_method("take_damage"):
		if hasbounced:
			body.take_damage(damage)
			queue_free()
