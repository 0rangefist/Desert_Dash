extends Control
var current_popup: Control

# brings popup on screen for a few seconds
func show_task_complete_popup(task):
	$TaskCompletePopup.set_description(task.description)
	$TaskCompletePopup.auto_popup()
	
	# Logic to modify the task complete popup
	
	
func show_daily_challenge_complete_popup():
	#$DailyChallengeCompletePopup.auto_popup()
	pass

# when a task of the daily challenge is completed, show a victory popup
func _on_daily_challenge_task_completed(task):
	show_task_complete_popup(task)
