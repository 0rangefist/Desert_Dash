extends Node3D

var rotation_speed = PI  # Adjust the speed of rotation

func _ready():
	# You can add any setup code here
	pass

func _process(delta):
	# Rotate the coin in place
	rotate(Vector3.UP, rotation_speed * delta)


func _on_player_encountered(body):
	# This function is called player is encountered
	if body.get_name() == "Player":
		body.collect_coin()
		queue_free()  # Remove the coin from the scene
		# Optionally, play a collection animation here
