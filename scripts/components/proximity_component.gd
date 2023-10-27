extends Area3D
# this component detects when a player is in proximity
# to a target (this node's parent) and turns on the target recticle

func _on_body_entered(body):
	# if the body is the player
	if body.name == "Player":
		var player = body
		#turn on player.in_target_proximity
		player.in_target_proximity = true
		if player.ammo > 0:
			# aim player raycast (lookat) at this node's parent
			var target = get_parent()
			player.raycast.look_at(target.global_position)
			# turn on target recticle
			player.cross_hairs.on()
			# aim the recticle at the target as well
			var plane = load("res://scenes/objects/magnet.tscn").instantiate()
			add_child(plane)
			plane.global_position =  target.global_position
			
			var pos2D = get_viewport().get_camera_3d().unproject_position(target.global_position)
			player.cross_hairs.position = pos2D
			


func _on_body_exited(body):
	# if the body is the player
	if body.name == "Player":
		var player = body
		# turn of player.in_target_proximity
		player.in_target_proximity = false
		# turn off target recticle
		player.cross_hairs.off()
		player.cross_hairs.disengage()
