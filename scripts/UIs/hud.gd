extends Control

# COINS
func _on_player_coin_collected(coin_count):
	$CoinCount.text = str(coin_count)

# SHIELD
func _on_player_shield_collected():
	$Shield/ProgressBar.set_max(30)
	$Shield/ProgressBar.value = 30 

func _on_player_shield_up(up_time):
	$Shield/ProgressBar.set_max(up_time * 10)
	$Shield/ProgressBar.value = up_time * 10 
	$Shield/ProgressTimer.set_wait_time(0.1)
	$Shield/ProgressTimer.start()

func _on_player_shield_dropped():
	$Shield/ProgressBar.value = 0
	$Shield/ProgressTimer.stop()

func _on_shield_progress_timer_timeout():
	# increase the progress indicator
	if $Shield/ProgressBar.value > 0:
		$Shield/ProgressBar.value -= 1

# HOVER
func _on_player_hover_collected():
	$Hover/ProgressBar.set_max(30)
	$Hover/ProgressBar.value = 30 

func _on_player_hover_on(on_time):
	$Hover/ProgressBar.set_max(on_time * 10)
	$Hover/ProgressBar.value = on_time * 10 
	$Hover/ProgressTimer.set_wait_time(0.1)
	$Hover/ProgressTimer.start()

func _on_player_hover_dropped():
	$Hover/ProgressBar.value = 0
	$Hover/ProgressTimer.stop()
	
func _on_hover_progress_timer_timeout():
	# increase the progress indicator
	if $Hover/ProgressBar.value > 0:
		$Hover/ProgressBar.value -= 1
	
# SCORE TIME
# update the score time every second
func _on_player_score_one_second_elapsed(total_score_time):
	$ScoreTime.text = Global.format_time(total_score_time)

func _on_daily_challenge_task_progressed(_task_descriptions):
#	print("DAILY CHALLENGE TASKS")
#	for task_description in task_descriptions:
#		print(task_description)
	pass

func _on_daily_challenge_task_completed(task):
	print("You Completed a Task: " + task.description)
