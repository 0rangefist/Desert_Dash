extends Control
	
func _on_player_coin_collected(coin_count):
	$CoinCount.text = "Coins: " + str(coin_count)
	

func _on_player_shield_collected():
	$ShieldSprite.stop()
	$ShieldSprite.visible = true
	$ShieldSprite/ProgressBar.visible = false

func _on_player_shield_up(up_time):
	# enable and play shield animated sprite
	$ShieldSprite.play()
	$ShieldSprite.visible = true
	$ShieldSprite/ProgressBar.visible = true
	$ShieldSprite/ProgressBar.set_max(up_time * 10)
	$ShieldSprite/ProgressBar.value = up_time * 10 
	$ShieldSprite/ProgressTimer.set_wait_time(0.1)
	$ShieldSprite/ProgressTimer.start()

func _on_player_shield_dropped():
	$ShieldSprite.visible = false

func _on_progress_timer_timeout():
	# increase the progress indicator
	if $ShieldSprite/ProgressBar.value > 0:
		$ShieldSprite/ProgressBar.value -= 1

# update the score time every second
func _on_gameplay_one_second_elapsed(total_gameplay_time):
	$ScoreTime.text = format_time(total_gameplay_time)

# helper function to format time from secs to 00m:00s
func format_time(total_time):
	var minutes = int(total_time / 60)
	var seconds = total_time % 60
	return "Time: " + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
