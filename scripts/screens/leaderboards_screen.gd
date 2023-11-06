extends Control
	
# hide the screen when appropriate button pressed
func _on_close_button_pressed():
	hide()

func _on_survival_leaderboard_button_pressed():
	if Global.GPGS:
		Global.GPGS.showLeaderBoard(Global.SURVIVAL_LEADERBOARD)

func _on_challenge_leaderboard_button_pressed():
	if Global.GPGS:
		Global.GPGS.showLeaderBoard(Global.CHALLENGE_LEADERBOARD)
