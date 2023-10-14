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

