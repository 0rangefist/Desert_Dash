extends CanvasLayer

func _on_settings_button_pressed():
	# pause the game
	get_tree().paused = true
	# make settings popup menu visible
	$SettingsScreen.show()	

func _on_daily_challenges_button_pressed():
	# pause the game
	get_tree().paused = true
	# make daily challenges popup menu visible
	$DailyChallengesScreen.show()

func _on_pause_button_pressed():
	# toggle pause on/off
	get_tree().paused = !get_tree().paused

func _on_popup_screen_hidden():
	# unpause the game
	get_tree().paused = false
	
