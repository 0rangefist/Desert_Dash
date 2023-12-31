extends CharacterBody3D

# controls
const HOVER_VELOCITY = 7
const REBOUND_AMT = 1  # the distance to rebound
const MOVE_DURATION = 0.1  # time taken to move left/right
const SPEED = 12 # driving speed of the player
const DELTA_SPEED = 0.0 # offset per frame to accelerate player over time
var delta_speed = DELTA_SPEED
var lane = { 'LEFT': -5, 'CENTER': 0, 'RIGHT': 5}
var player_position = lane.CENTER

const SHIELD_UP_TIME = 6  # num of secs shield is active
var shield_in_collection = false
var shield_is_up = false
var shield_up_timer = Timer.new()

const MAGNET_ON_TIME = 7  # num of secs magnet is active
var magnet_on_timer = Timer.new()

const HOVER_ON_TIME = 6 # num of secs player can use hover
var hover_on_timer = Timer.new()
var hover_in_collection = false
var hover_is_on = false


# collectables
var coin_count = 0

# signals
signal coin_collected
signal shield_collected
signal shield_up
signal shield_dropped
signal magnet_collected
signal magnet_dropped
signal hover_collected
signal hover_on
signal hover_dropped
signal score_one_second_elapsed
signal cactus_squashed
signal roof_driven_on

# collision/mask layers
const LAYER = {'PLAYER': 1, 'GROUND': 2, 'OBSTACLES': 3, 'COLLECTIBLES': 4}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Total time the game has been running in seconds
var total_score = 0

# collisions
var registered_roof_colliders: Dictionary = {}
const MAX_REGISTERED_ROOF_COLLIDERS = 3

func _ready():
	# timer for hover on starts
	hover_on_timer.timeout.connect(_on_hover_on_timer_timeout)
	add_child(hover_on_timer)
	hover_on_timer.wait_time = HOVER_ON_TIME
	# timer for magnet ability starts
	magnet_on_timer.timeout.connect(_on_magnet_on_timer_timeout)
	add_child(magnet_on_timer)
	magnet_on_timer.wait_time = MAGNET_ON_TIME
	# timer for shield effect (collision off) starts
	shield_up_timer.timeout.connect(_on_shield_up_timer_timeout)
	add_child(shield_up_timer)
	shield_up_timer.wait_time = SHIELD_UP_TIME

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		#$DustTrail.emitting = false
	#else:
		#$DustTrail.emitting = false
	
	# set player in perpetual motion
	#position.z -= 0.1
	delta_speed += DELTA_SPEED
	velocity.z = -1 * (SPEED + delta_speed) 
	

	# KEYBOARD INPUT DETECTION
	if Input.is_action_just_pressed("left"):
		move_left()
	elif Input.is_action_just_pressed("right"):
		move_right()
	if Input.is_action_pressed("up"):
		hover()
		# for testing purposes, move forward
		#position.z -= 0.2
	if Input.is_action_pressed("down"):
		# activate shield if in collection and not up already
		if shield_in_collection and !shield_is_up:
			put_up_shield()
		# for testing purposes
		#position.z += 0.5
	detect_obstacle_collision()
	move_and_slide()

# SWIPE INPUT DETECTION
func _on_swipe_detector_down_swipe():
	# activate shield if in collection and not up already
	if shield_in_collection and !shield_is_up:
		put_up_shield()

func _on_swipe_detector_left_swipe():
	move_left()

func _on_swipe_detector_right_swipe():
	move_right()

func _on_swipe_detector_up_swipe():
	hover()

# Movement
func move_left():
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	if player_position == lane.CENTER:
		# translate player left by MOVE_AMT
		tween.tween_property(self, "position:x", lane.LEFT, MOVE_DURATION)
		# update lane to left
		player_position = lane.LEFT
	elif player_position == lane.RIGHT:
		# translate player left
		tween.tween_property(self, "position:x", lane.CENTER, MOVE_DURATION)
		# update lane to center
		player_position = lane.CENTER
	else: # player already in left lane
		# rebound the player against left boundary
		tween.tween_property(self, "position:x", lane.LEFT - REBOUND_AMT, MOVE_DURATION).set_trans(Tween.TRANS_SPRING)
		#tween.tween_interval(0.1)
		tween.tween_property(self, "position:x", lane.LEFT, MOVE_DURATION)
	
func move_right():
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	if player_position == lane.CENTER:
		# Translate player right by MOVE_AMT
		tween.tween_property(self, "position:x", lane.RIGHT, MOVE_DURATION)
		# Update lane to right
		player_position = lane.RIGHT
	elif player_position == lane.LEFT:
		# Translate player right
		tween.tween_property(self, "position:x", lane.CENTER, MOVE_DURATION)
		# Update lane to center
		player_position = lane.CENTER
	else: # Player already in right lane
		# Rebound the player slightly to the right and back to the same position
		tween.tween_property(self, "position:x", lane.RIGHT + REBOUND_AMT, MOVE_DURATION).set_trans(Tween.TRANS_SPRING)
		#tween.tween_interval(0.1)
		tween.tween_property(self, "position:x", lane.RIGHT, MOVE_DURATION)

func hover():
	# allow hovering only if hover pack in collection
	if hover_in_collection:
		# dispalce the player upward if the hover pack is on
		if hover_is_on and position.y < 7:
			$HoverSound.play()
			velocity.y = HOVER_VELOCITY
		# if hover pack isn't already on, turn it on & displace player
		elif !hover_is_on:
			$HoverSound.play()
			turn_on_hover()
			velocity.y = HOVER_VELOCITY

# OBJECT COLLECTION
func collect_coin():
	print("PLAYER COLLECTED A COIN")
	coin_count += 1
	# Send signal to Update UI
	coin_collected.emit(coin_count)

func collect_magnet():
	print("PLAYER COLLECTED A MAGNET")
	magnet_collected.emit()
	# turn on magnet
	$MagnetBox.monitoring = true
	magnet_on_timer.start()

func _on_magnet_on_timer_timeout():
	print("MAGNET ON TIME EXPIRED")
	# turn off magnet
	$MagnetBox.monitoring = false
	magnet_on_timer.stop()

func _on_magnet_box_area_entered(collectible):
	var time_to_arrive = 0.1
	# Calculate the expected player position when the coin arrives
	var expected_position = global_position + (velocity * time_to_arrive)
	if collectible.is_in_group("coins"):
		print(collectible.name + " HAS ENTERED MAGNET BOX")
		var tween = create_tween()
		#tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		#tween.tween_property(collectible, "position", 2 * Vector3.UP, 0.2 )
		tween.tween_property(collectible, "global_position", expected_position, time_to_arrive)

func collect_shield():
	# collect shield if not already in collection
	if not shield_in_collection:
		print("PLAYER COLLECTED A SHIELD")
		# Update HUD to show player has shield in collection
		shield_collected.emit()
		shield_in_collection = true
	# if shield already in use, reset it's up time
	elif shield_in_collection and shield_is_up:
		put_up_shield()

func put_up_shield():
	$ShieldSound.play()
	shield_is_up = true
	print("PLAYER PUT UP A SHIELD")
	#  disable collision with obstacles
	set_collision_mask_value(LAYER.OBSTACLES, false)
	# signal emitted to HUD to display shield up time
	shield_up.emit(SHIELD_UP_TIME)
	shield_up_timer.start()

func _on_shield_up_timer_timeout():
	print("SHIELD UP TIME EXPIRED")
	# re-enable collision with obstacles
	set_collision_mask_value(LAYER.OBSTACLES, true)
	# remove shield from collection, so it can't be used again
	shield_in_collection = false
	shield_is_up = false
	shield_dropped.emit()
	shield_up_timer.stop()
	
func collect_hover():
	# collect hover if not already in collection
	if not hover_in_collection:
		print("PLAYER COLLECTED HOVER")
		# Update HUD to show player has shield in collection
		hover_collected.emit()
		hover_in_collection = true
	# if hover ability already active, reset it's up time
	elif hover_in_collection and hover_is_on:
		turn_on_hover()

func turn_on_hover():
	# turn on the ability to hover
	hover_is_on = true
	print("PLAYER TURNED ON HOVER")
	# signal emitted to HUD to display hover on time
	hover_on.emit(HOVER_ON_TIME)
	hover_on_timer.start()

func _on_hover_on_timer_timeout():
	print("HOVER TIME EXPIRED")
	# remove hover from collection, so it can't be used again
	hover_in_collection = false
	hover_is_on = false
	hover_dropped.emit()
	hover_on_timer.stop()

func detect_obstacle_collision():
	#print("VELOCITY GO: " + str(get_real_velocity().z))
	var collision = get_last_slide_collision()
	# get the last non-null, non-ground collision
	if collision and collision.get_collider() and collision.get_collider().name != "Ground" :
		var collider_name =  collision.get_collider().name
		var collision_angle = collision.get_angle()
		print("HEAVY COLLISION WITH " + collision.get_collider().name + ": " +  str(collision.get_angle()))
		# squash cactus if collision from above
		if "Cactus" in collider_name and collision_angle < 1:
			collision.get_collider().queue_free()
			cactus_squashed.emit()
		# if roof driven on (collision from above of building)
		elif "Building" in collider_name and collision_angle < 1:
			# get the unique instance id of the collider object
			var collider_id = collision.get_collider_id()
			# if collider not in register
			if !registered_roof_colliders.has(collider_id):
				print("Roof Driven on!")
				roof_driven_on.emit()
				# empty the whole dictionary if needed
				if registered_roof_colliders.size() == MAX_REGISTERED_ROOF_COLLIDERS:
					registered_roof_colliders = {}
				# add this very collider to register to avoid
				# registering repeated collisions with same collider
				registered_roof_colliders[collider_id] = true
		else:
				# Switch to the gameover screen
				SceneManager.switch_scene("res://scenes/screens/gameover_screen.tscn")
# keep count of gameplay time every second and notify HUD
func _on_score_timer_timeout():
	total_score += 1
	score_one_second_elapsed.emit(total_score)
	# Update the globals score variables
	Global.coin_count = coin_count
	Global.score = total_score
