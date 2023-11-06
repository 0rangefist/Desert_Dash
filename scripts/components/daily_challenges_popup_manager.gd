extends Control
var current_popup: Control

# brings popup on screen for a few seconds
func show_task_complete_popup(task):
	$TaskCompletePopup.set_description(task.description)
	$TaskCompletePopup.auto_popup()
	
func show_daily_challenge_complete_popup():
	$DailyChallengeCompletePopup.auto_popup()

# when a task of the daily challenge is completed, show a victory popup
func _on_daily_challenge_task_completed(task):
	print("You Completed a Task: " + task.description)
	show_task_complete_popup(task)
	
# when the daily challenge is completed, show a victory popup
func _on_daily_challenge_completed():
	print("You Completed the Daily Challenge")
	show_daily_challenge_complete_popup()
