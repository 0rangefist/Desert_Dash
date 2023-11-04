extends Node

var paused = false

func pause():
	# toggle pause state
	paused = !paused
	
	if paused:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1
