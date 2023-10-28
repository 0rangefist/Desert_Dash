extends Area3D

var rotation_speed = PI  # Adjust the speed of rotation

func _process(delta):
	# Rotate the coin in place
	rotate(Vector3.UP, rotation_speed * delta)

func _on_player_encountered(body):
	# This function is called player is encountered
	if body.get_name() == "Player":
		body.collect_hover()
		queue_free()  # Remove the hover pack from the scene
