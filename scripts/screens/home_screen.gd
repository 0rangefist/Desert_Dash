extends Control

var main_scene_path = "res://scenes/world.tscn"
var use_loading_screen = true
	

func _on_play_button_pressed():
	# call scene manager and ask to switch to main game scene
	SceneManager.switch_scene(main_scene_path, use_loading_screen)

func _on_settings_button_pressed():
	# make settings popup menu visible
	$SettingsScreen.show()
	# block other buttons while popup is visible
	$InputBlocker.show()

func _on_daily_challengse_button_pressed():
	# make daily challenges popup menu visible
	$DailyChallengesScreen.show()
	# block other buttons while popup is visible
	$InputBlocker.show()

func _on_leader_boards_button_pressed():
	# show leaderboards
	if Global.GPGS:
		Global.GPGS.showAllLeaderBoards()

func _on_popup_screen_hidden():
	# when a popup is cosed (hidden)
	# re-hide the InputBlocker control node
	$InputBlocker.hide()
