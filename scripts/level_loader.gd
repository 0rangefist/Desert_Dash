class_name LevelLoader
extends Node

# array of units of the current level
var level_units = []

const levels_path = "res://scenes/levels/"

# to be determined dynamicall from subdirs in level dir
var level_names = []

func _init():
	_update_level_names()

func load_level(level_name):
	# if level_name is valid
	if level_name in level_names:
		# go ahead to load the levels units
		_load_level_units(level_name)
	else:
		print("Error: Couldn't load level: " + level_name + ". It doesn't exist")
	
func _update_level_names():
	# scan level dir for subdirs (which are the level names)
	# open the level directory
	var dir = DirAccess.open(levels_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found a level name: " + file_name)
				level_names.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Error: Couldn't access the levels directory ")
				
func _load_level_units(level_name):
	# construct the level's dir path
	var level_path = levels_path + level_name + "/"
	print("LEVEL PATH: " + level_path)
	var dir = DirAccess.open(level_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# check if the file is a scene file (ends with ".tscn")
			if file_name.ends_with(".tscn"):
				# construct the path of the scene
				var unit_scene_path = level_path + file_name
				# load the unit
				print("UNIT PATH: " + unit_scene_path)
				var unit_scene = load(unit_scene_path)
				# add the scene to the level_units array
				level_units.append(unit_scene)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Error: Couldn't access the directory: " + level_path)
