extends Node3D

@export_range(0.0, 1.0, 0.1) var building_probability: float  = 0.2
@export_range(0.0, 1.0, 0.1) var car_wreck_probability: float  = 0.1
@export_range(0.0, 1.0, 0.1) var cactus_probability: float  = 0.8
@export_range(0.0, 1.0, 0.1) var rock_probability: float  = 0.2
@export_range(0.0, 1.0, 0.1) var skeleton_probability: float  = 0.1
@export_range(0.0, 1.0, 0.1) var tree_probability: float  = 0.1
@export_range(0.0, 1.0, 0.1) var wall_probability: float  = 0.1
@export_range(0.0, 1.0, 0.1) var well_probability: float  = 0.1

var buildings: PackedScene
var cacti: PackedScene
var car_wrecks: PackedScene
var rocks: PackedScene
var skeletons: PackedScene
var trees: PackedScene
var walls: PackedScene
var wells: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# preload all the obstacles for spawning
	buildings = preload("res://scenes/objects/buildings.tscn")
	cacti= preload("res://scenes/objects/cacti.tscn")
#	car_wrecks = preload("res://scenes/objects/car_wrecks.tscn")
#	rocks = preload("res://scenes/objects/rocks.tscn")
#	skeletons = preload("res://scenes/objects/skeletons.tscn")
#	trees = preload("res://scenes/objects/trees.tscn")
#	walls = preload("res://scenes/objects/walls.tscn")
#	wells = preload("res://scenes/objects/wells.tscn")
	
	# randomly spawn an obstacle
	randomly_spawn_obstacle()

func randomly_spawn_obstacle():
	var obstacle_types = {
		"buildings": [buildings, building_probability],
		"cacti": [cacti, cactus_probability]
	}
#		"car_wrecks": [car_wrecks, car_wreck_probability],
#	    "rocks": [rocks, rock_probability],
#	    "skeletons": [skeletons, skeleton_probability],
#	    "trees": [trees, tree_probability],
#	    "walls": [walls, wall_probability],
#	    "wells": [wells, well_probability]

	# Get a random float between 0.0 and 1.0
	var rand_num = randf()
	var cumulative_probability = 0.0
	var obstacle_probability
	var selected_obstacle_type = null
	for key in obstacle_types:
		obstacle_probability = obstacle_types[key][1]
		cumulative_probability += obstacle_probability
		if rand_num < cumulative_probability:
			selected_obstacle_type = obstacle_types[key][0]
			break

	# Now, 'selected_obstacle_type' contains the chosen obstacle type
	# Use it to spawn the appropriate obstacle
	if selected_obstacle_type:
		spawn_obstacle(selected_obstacle_type)
		
func spawn_obstacle(obstacle_type: PackedScene):
	var instance = obstacle_type.instantiate()
	var num_of_variations = instance.get_child_count()
	var rand_index = randi_range(0, num_of_variations - 1)
	var obstacle = instance.get_child(rand_index).duplicate()
	add_child(obstacle)
	
