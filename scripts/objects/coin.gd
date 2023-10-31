extends Node3D

var rotation_speed = 4  # Adjust the speed of rotation
@onready var connect_sound_signal = $Sound.finished.connect(_on_sound_playback_finished)

func _ready():
	# Generate a random starting angle
	var initial_rotation = randi_range(0, 4) * (0.75 * PI) 
	rotate(Vector3.UP, initial_rotation)

func _process(delta):
	# Rotate the coin in place
	rotate(Vector3.UP, rotation_speed * delta)


func _on_player_encountered(body):
	# This function is called player is encountered
	$Sound.play()
	if body.get_name() == "Player":
		body.collect_coin()
		# hide the coin
		visible = false

func _on_sound_playback_finished():
	queue_free()  # Remove the coin from the scene
