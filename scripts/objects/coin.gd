extends Node3D

var rotation_speed = 4  # Adjust the speed of rotation

func _ready():
	# Generate a random starting angle
	var initial_rotation = randi_range(0, 4) * (0.75 * PI) 
	rotate(Vector3.UP, initial_rotation)

func _process(delta):
	# Rotate the coin in place
	rotate(Vector3.UP, rotation_speed * delta)


func _on_player_encountered(body):
	# This function is called player is encountered
	if body.get_name() == "Player":
		body.collect_coin()
		queue_free()  # Remove the coin from the scene
		# Optionally, play a collection animation here
