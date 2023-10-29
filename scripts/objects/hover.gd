extends Area3D

var rotation_speed = PI  # Adjust the speed of rotation

func _process(delta):
	# Connect sound signal
	$Sound.finished.connect(_on_sound_playback_finished)
	# Rotate the coin in place
	rotate(Vector3.UP, rotation_speed * delta)

func _on_player_encountered(body):
	$Sound.play()
	# This function is called player is encountered
	if body.get_name() == "Player":
		body.collect_hover()
		# hide the hover pack
		visible = false

func _on_sound_playback_finished():
	queue_free()  # Remove the hover pack from the scene
