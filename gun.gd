extends CharacterBody2D

func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * 400
	move_and_slide()

func _process(delta):
	look_at(get_global_mouse_position())
