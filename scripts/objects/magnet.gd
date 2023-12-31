extends Node3D

var rotation_speed = PI  # Adjust the speed of rotation
@onready var connect_sound_signal = $Sound.finished.connect(_on_sound_playback_finished)

func _process(delta):
	# Rotate the coin in place
	rotate(Vector3.UP, rotation_speed * delta)


func _on_player_encountered(body):
	# This function is called player is encountered
	$Sound.play()
	if body.get_name() == "Player":
		body.collect_magnet()
		# hide the magnet
		visible = false

func _on_sound_playback_finished():
	queue_free()  # Remove the magnet from the scene
