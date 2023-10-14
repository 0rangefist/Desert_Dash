extends CharacterBody3D

# controls
const JUMP_VELOCITY = 4.5
const REBOUND_AMT = 1  # the distance to rebound
const MOVE_DURATION = 0.1  # time taken to move left/right
var lane = { 'LEFT': -5, 'CENTER': 0, 'RIGHT': 5}
var player_position = lane.CENTER

# collectables
var coin_count = 0

# signals
signal coin_collected
signal shield_collected
signal shield_dropped
signal magnet_collected
signal magnet_dropped

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#if Input.is
	
	if Input.is_action_just_pressed("move_left"):
		move_player_left()
	elif Input.is_action_just_pressed("move_right"):
		move_player_right()
	if Input.is_action_pressed("trigger_up"):
		#fire_weapon()
		# for testing purposes
		position.z -= 0.5
	if Input.is_action_pressed("trigger_down"):
		# for testing purposes
		position.z += 0.5

	move_and_slide()

# Movement
func move_player_left():
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
	
func move_player_right():
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

func fire_weapon():
	velocity.y = JUMP_VELOCITY
	
# Object Collection
func collect_coin():
	print("PLAYER COLLECTED A COIN!!!")
	coin_count += 1
	# Send signal to Update UI
	emit_signal("coin_collected", coin_count)

func collect_magnet():
	print("PLAYER COLLECTED A MAGNET!!!")
	magnet_collected.emit()
	# timer for magnet ability starts
	# logic to detect coins within a certain radius
	# all those coins are collected self.collect_coin
	# animation played for each coin 
	# timer expires, magnet ability stops
	magnet_dropped.emit()
	
func collect_shield():
	print("PLAYER COLLECTED A SHIELD!!!")
	shield_collected.emit()
	# disable collision with the world
	set_collision_layer_value(0, false)
	# timer for shield ability starts
	await get_tree().create_timer(5).timeout
	# enable collision with the world
	set_collision_layer_value(0, true)
	shield_dropped.emit()


# Swipe Detection
func _on_swipe_detector_down_swipe():
	pass # Replace with function body.

func _on_swipe_detector_left_swipe():
	move_player_left()

func _on_swipe_detector_right_swipe():
	move_player_right()

func _on_swipe_detector_up_swipe():
	fire_weapon()
