extends Node

var MAX_VISIBLE_UNITS = 5  # Maximum number of visible level units
var UNIT_SPEED = 20.0  # Speed at which units move
var UNIT_LENGTH = 35.0  # Length of each unit

var leftmost_position = 0.0  # Initial leftmost position
var rightmost_position = 0.0  # Initial rightmost position

# Store the instantiated level units in an array
var level_units = []

var level_loader = LevelLoader.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	level_loader.load_level("desert")
	# randomly instantiate the first visible set of units
	for cycle in range(MAX_VISIBLE_UNITS):
		var unit = get_random_unit_instance(level_loader.level_units)
		add_child(unit)
		unit.global_transform.origin.z = rightmost_position
		# update value of rightmost position
		rightmost_position -= UNIT_LENGTH
		level_units.append(unit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var unit_velocity = Vector3(0, 0, UNIT_SPEED)
	
	for unit in level_units:
		unit.global_translate(unit_velocity * delta)
		
		# check if unit has moved off screen
		if unit.global_transform.origin.z - UNIT_LENGTH > leftmost_position:
			# instatiate a new one
			var new_unit = get_random_unit_instance(level_loader.level_units)
			add_child(new_unit)
			# move the new unit instance to the rightmost position
			new_unit.global_transform.origin.z = rightmost_position + UNIT_LENGTH
			# remove the old unit from the tracking array
			level_units.erase(unit)
			# add the new unit to the tracking array
			level_units.append(new_unit)
			unit.queue_free() # free the unit

func get_random_unit_instance(unit_list):
	# Randomly select an instantiate unit scene from list
	return unit_list[randi() % unit_list.size()].instantiate()

#func test_level_loader():
#	var level_loader = LevelLoader.new()
#	level_loader.load_level("desert")  # Replace "Level1" with the desired level name
#
#	# Log the loaded unit scenes
#	for unit_scene in level_loader.level_units:
#		# create an instance
#		var unit = unit_scene.instantiate()
#		print("Loaded unit instance:", unit.visible)
#		add_child(unit)
