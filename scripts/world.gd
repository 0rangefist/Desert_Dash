extends Node

var MAX_VISIBLE_UNITS = 3  # Maximum number of visible level units(not less than 2)
var UNIT_LENGTH = 35.0  # Length of each unit

var player_start_pos = 0.0 
var nearest_position = 0.0 # previous unit is del when player passes this point
var farthest_position = 0.0  # newe unit is added after this point

# Store the instantiated level unit  in an array
var visible_units = []

var level_loader = LevelLoader.new()
var daily_challenge

# Called when the node enters the scene tree for the first time.
func _ready():
	daily_challenge = await DailyChallenge.new()
	level_loader.load_level("desert")
	# setup the nearest pos to be origin of the 2nd unit
	nearest_position -= UNIT_LENGTH
	# randomly instantiate the first visible set of units
	for cycle in range(MAX_VISIBLE_UNITS):
		var unit = get_random_unit_instance(level_loader.level_units)
		# add the unit to the scene
		add_child(unit)
		# position the unit at the furthest position
		unit.global_transform.origin.z = farthest_position
		# update value of farthest position
		farthest_position -= UNIT_LENGTH
		# add the unit to the tracking array
		visible_units.append(unit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
		
		var first_unit = visible_units[0]
		var second_unit = visible_units[1]
		print("PLAYER GLOBAL POS: " + str($Player.global_position.z))
		print("UNIT GLOBAL POS: " + str(visible_units[0].global_position.z))
		# if the moving player passes the origin of the 2nd visible unit,
		# the first unit is erased, and a new unit appended to visible_units array
		if $Player.global_position.z < nearest_position:
			print("LOOP PLAYER GLOBAL POS: " + str($Player.global_position.z))
			print("LOOP 2nd Unit GLOBAL POS: " + str(second_unit.global_position.z))
			# instatiate a new unit
			var new_unit = get_random_unit_instance(level_loader.level_units)
			# add the new unit to the scene
			add_child(new_unit)
			# move the new unit instance to the farthest position
			new_unit.global_transform.origin.z = farthest_position
			# delete the first unit from the tracking array
			visible_units.erase(first_unit)
			# add the new unit to the tracking array
			visible_units.append(new_unit)
			# free the first unit from the scene
			first_unit.queue_free() 
			# update the nearest & farthest positions for use in the next frame
			nearest_position -= UNIT_LENGTH
			farthest_position -= UNIT_LENGTH


func get_random_unit_instance(unit_list):
	# Randomly select an instantiate unit scene from list
	return unit_list[randi() % unit_list.size()].instantiate()

static func _random_direction() -> Vector3:
	return (Vector3(randf(), randf(), randf()) - Vector3.ONE / 2.0).normalized() * 2.0
#func test_level_loader():
#	var level_loader = LevelLoader.new()
#	level_loader.load_level("desert")  # Replace "Level1" with the desired level name
#
#	# Log the loaded unit scenes
#	for unit_scene in level_loader.visible_units:
#		# create an instance
#		var unit = unit_scene.instantiate()
#		print("Loaded unit instance:", unit.visible)
#		add_child(unit)
