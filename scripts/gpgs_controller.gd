extends Control

var GPGS
var main_scene_path = "res://scenes/world.tscn"
var use_loading_screen = true

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
		
		
func _on_sign_in_success(user_info):
	print("Sign in success: " + user_info)

func _on_sign_in_failed(error_code: int):
	print("Sign in failed: " + str(error_code))
	
func _on_sign_out_success():
	print("Sign out success" )

func _on_sign_out_failed():
	print("Sign out failed")
	
func _on_play_pressed():
	# call scene manager and ask to switch to main game scene
	SceneManager.switch_scene(main_scene_path, use_loading_screen)

func _on_sign_in_pressed():
	if GPGS:
		GPGS.signIn()

func _on_sign_out_pressed():
	if GPGS:
		GPGS.signOut()
