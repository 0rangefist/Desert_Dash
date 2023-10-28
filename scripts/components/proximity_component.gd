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
			player.recticle.on()
			# aim the recticle at the target as well
			
			#var plane = load("res://scenes/components/recticle_component.tscn").instantiate()
			#add_child(plane)
			#plane.on()
			var pos2D = get_viewport().get_camera_3d().unproject_position(target.global_position)
			#plane.global_position = pos2D
			player.recticle.global_position = pos2D
			
			#var pos2D = get_viewport().get_camera_3d().unproject_position(target.global_position)
			#player.recticle.global_position = target.global_position
			


func _on_body_exited(body):
	# if the body is the player
	if body.name == "Player":
		var player = body
		# turn of player.in_target_proximity
		player.in_target_proximity = false
		# turn off target recticle
		player.recticle.off()
		player.recticle.disengage()
