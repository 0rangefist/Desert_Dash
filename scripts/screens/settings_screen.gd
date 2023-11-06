extends Control

var GPGS

func _ready():
	if Engine.has_singleton("GodotPlayGamesServices"):
		GPGS = Engine.get_singleton("GodotPlayGamesServices")
		var show_popups := true
		var request_email := false
		var request_profile := true
		var request_token := ""
		GPGS.init(show_popups, request_email, request_profile, request_token)
		GPGS.connect("_on_sign_in_success", _on_sign_in_success)
		GPGS.connect("_on_sign_in_failed", _on_sign_in_failed)
		GPGS.connect("_on_sign_out_success", _on_sign_out_success)
		GPGS.connect("_on_sign_out_failed", _on_sign_out_failed)
		
		# initialise settings popup with correct sign in state from GPGS
		if GPGS:
			if GPGS.isSignedIn():
				# set the button state to pressed (representing signed in)
				$PlayGamesButton.button_pressed = true
				# diaplay option to user to sign out
				$PlayGamesButton.text = "DISCONNECT"
			else: # not signed in
				# set the button state to not pressed (representing signed out)
				$PlayGamesButton.button_pressed = false
				# display option to the user to sign in
				$PlayGamesButton.text = "CONNECT"
		
		
func _on_sign_in_success(user_info):
	print("Sign in success: " + user_info)
	# Change toggle button to now show disconnect
	$PlayGamesButton.text = "DISCONNECT"

func _on_sign_in_failed(error_code: int):
	print("Sign in failed: " + str(error_code))
	
func _on_sign_out_success():
	print("Sign out success" )
	# Change toggle button to now show connect
	$PlayGamesButton.text = "CONNECT"

func _on_sign_out_failed():
	print("Sign out failed")

func _on_connect_toggled(button_pressed):
	if button_pressed:
		if GPGS:
			GPGS.signIn()
			$PlayGamesButton.text = "CONNECTING ..."
	else:
		if GPGS:
			GPGS.signOut()
			$PlayGamesButton.text = "DISCONNECTING ..."
	
func _on_sign_in_pressed():
	if GPGS:
		GPGS.signIn()

func _on_sign_out_pressed():
	if GPGS:
		GPGS.signOut()

func _on_close_button_pressed():
	hide()
