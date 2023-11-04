extends Control

var main_scene_path = "res://scenes/world.tscn"
var use_loading_screen = true
	

func _on_play_button_pressed():
	# call scene manager and ask to switch to main game scene
	SceneManager.switch_scene(main_scene_path, use_loading_screen)


func _on_settings_button_pressed():
	if $SettingsScreen.visible:
		$SettingsScreen.hide()
	else:
		$SettingsScreen.show()
