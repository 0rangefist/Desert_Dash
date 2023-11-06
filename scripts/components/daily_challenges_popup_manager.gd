extends Control
var current_popup: Control

# brings popup on screen for a few seconds
func show_task_complete_popup(task):
	$TaskCompletePopup.set_description(task)
	$TaskCompletePopup.auto_popup()
	
	# Logic to modify the task complete popup
	
	
func show_daily_challenge_complete_popup():
	#$DailyChallengeCompletePopup.auto_popup()
	pass
