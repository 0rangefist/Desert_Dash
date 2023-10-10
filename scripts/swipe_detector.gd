extends Camera2D

var swipe_length =  100
var start_positiion
var current_position
var swiping = false
var axis_detection_sensitivity = 0.5 # 0 to 1 

# swipe signals
signal left_swipe
signal right_swipe
signal up_swipe
signal down_swipe

func _process(_delta):
	
	# detect initial press
	if Input.is_action_just_pressed('press'):
		if not swiping:
			swiping = true
		# record this start position of the swipe
		start_positiion = get_global_mouse_position()
		print("Swipe Start Pos: ", start_positiion)
	
	# track the current postiion of the swipe while swiping
	if Input.is_action_pressed('press'):
		if swiping:
			current_position = get_global_mouse_position()
			print("Swipe Current Pos: ", current_position)
			# calculate if swipe is long enough
			# to actually be considered a swipe
			if current_position.distance_to(start_positiion) >= 100:
				print("Swipe Happened!")
				# get the vector that represents length and direction of swipe
				var swipe_vector = current_position - start_positiion
				# xy_axis_ratio = 1 if the swipe is perfectly diagonal
				var xy_axis_ratio = abs(swipe_vector.x / swipe_vector.y)
				
				# horizontal swipes
				if xy_axis_ratio > 1 + axis_detection_sensitivity:
					# right horizontal swipe will be a +ve vector.x
					if swipe_vector.x > 0:
						print("Right Swipe")
						right_swipe.emit()
					# left horizontal swipe is a -ve vector.x
					else:
						print("Left Swipe")
						left_swipe.emit()
				
				# vertical swipes
				elif xy_axis_ratio < 1 - axis_detection_sensitivity:
					# up vertical swipe is a -ve vector.y
					if swipe_vector.y < 0:
						print("Up Swipe")
						up_swipe.emit()
					# down vertical swipe is a +ve vector.y
					else:
						print("Down Swipe")
						down_swipe.emit()
				# done swiping
				swiping = false
				
	else: # swiping state is reset if press isn't held down
		swiping = false
			
		
