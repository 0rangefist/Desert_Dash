class_name DailyChallenge
extends Node

var server_fetch_time = ""
var local_fetch_time = ""
var expiration_time = ""
var tasks = []  # the actual challege tasks
var endpoint = "https://0rangefist.pythonanywhere.com/api/daily-challenge"
var http

signal daily_challenge_fetched

func get_daily_challenge():
	self.load_from_storage()
	if self.tasks:
		print("Challenge loaded from storage")
		if self.is_expired():
			print("Challenge from storage expired so trying to fetch from remote")
			# Challenge is expired, fetch from the server (using await)
			self.fetch_from_remote()
		else:
			# emit signal that challenge is fetched
			daily_challenge_fetched.emit()
	else:
		print("Try to fetch Challenge from remote")
		# Data doesn't exist in local storage, fetch from the server (using await)
		self.fetch_from_remote()

func fetch_from_remote():
	# fetch data from api
	#var data
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	http.request(endpoint)
	
	

func _on_request_completed(_result, response_code, _headers, body):
	# parse the json string into a dictionary
	var data = JSON.parse_string(body.get_string_from_utf8())
	print("HTML BODY: " + str(data))
	if response_code == 200 and data:
		# extract data into instance attributes
		tasks = data.tasks
		server_fetch_time = data.server_fetch_time
		local_fetch_time = Time.get_datetime_string_from_system(true)
		expiration_time = data.expiration_time
	
		daily_challenge_fetched.emit()
		self.save_to_storage()
		print("Fetch from remote successful!")

func save_to_storage():
	# create a dictionary of the challenge instance
	var challenge_dict = {
		"server_fetch_time": server_fetch_time,
		"local_fetch_time": local_fetch_time,
		"expiration_time": expiration_time,
		"tasks": tasks,
	}
	# serialize the the dictionary
	var challenge_json = JSON.stringify(challenge_dict)
	var save_game = FileAccess.open("user://daily_challenge.save", FileAccess.WRITE)
	if challenge_json:
		save_game.store_line(challenge_json)
		
	
func load_from_storage():
	# check that the save file exists
	if not FileAccess.file_exists("user://daily_challenge.save"):
		return false
	# load challenge json data from storage
	var save_game = FileAccess.open("user://daily_challenge.save", FileAccess.READ)
	var challenge_json = save_game.get_line()
	# deserialize the json string
	var challenge_dict = JSON.parse_string(challenge_json)
	
	# repopulate instance attributes if valid dictionary
	if challenge_dict:
		server_fetch_time = challenge_dict.server_fetch_time
		local_fetch_time = challenge_dict.local_fetch_time
		expiration_time = challenge_dict.expiration_time
		tasks = challenge_dict.tasks
		return true
	return false


func is_expired():
	# check if local time's been set backwards since challenge was last fetched
	# if current local time < saved local fetch time
	var curr_local_time = Time.get_unix_time_from_system()
	var prev_local_fetch_time = Time.get_unix_time_from_datetime_string(self.local_fetch_time)
	print("Current local time:")
	print(Time.get_datetime_dict_from_system())
	print("Previous local fetch time:")
	print(Time.get_datetime_dict_from_datetime_string(self.local_fetch_time, true))
	if curr_local_time < prev_local_fetch_time:
		# this is deemed expired due to time manipulation, so fetch can
		# be redone and local-server time sync data is re-aquired
		print("Time manipulation expiration")
		return true
	# server time is the source of truth used to determine expiration.
	# relationship between server and local times is their fetch time difference
	var s_time = Time.get_unix_time_from_datetime_string(self.server_fetch_time) 
	var l_time =Time.get_unix_time_from_datetime_string(self.local_fetch_time)
	var time_diff = s_time - l_time
	# convert current local time into current server time using time_diff
	var curr_server_time = time_diff + Time.get_unix_time_from_system()
	print("Current Server Time")
	print(Time.get_datetime_dict_from_unix_time(curr_server_time))
	# we can now check if the challenge has expired
	var expiration = Time.get_unix_time_from_datetime_string(self.expiration_time)
	if curr_server_time >= expiration:
		print("Proper challenge expiration")
		return true
	return false
