extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while $MenuSound.playing == false:
		$MenuSound.pitch_scale = 0.7
		$MenuSound.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	$StartSound.volume_db = -15
	$StartSound.play()
	get_tree().change_scene_to_file("res://level.tscn")
	

func _on_options_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	$QuitSound.play()
	get_tree().quit()
