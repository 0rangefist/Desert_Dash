extends Node

const loading_screen_path = "res://scenes/screens/loading_screen.tscn"

func switch_scene(scene_path, use_loading_screen = false):
	# if scene to load should use loading screen
	if use_loading_screen:
		# preload and get instance of a loading_screen
		var loading_screen = preload(loading_screen_path).instantiate()
		# set the next scene to load after the loading screen
		loading_screen.scene_path = scene_path
		# add loading_screen to whatever scene it current
		get_tree().current_scene.get_children()
		get_tree().current_scene.add_child(loading_screen)
	else: # directly switch scenes without using loading screen
		get_tree().change_scene_to_file(scene_path)
