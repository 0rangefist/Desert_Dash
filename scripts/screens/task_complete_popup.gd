extends Control


func auto_popup():
	# show the popup
	show()
	# start timer
	$PopupTimer.start()

func _on_popup_timer_timeout():
	# hide the popup when the timer expires
	hide()
	
func set_popup_duration(duration):
	$PopupTimer.wait_time = duration

func set_description(text):
	var description = $TaskComplete/Description
	description.text = text
