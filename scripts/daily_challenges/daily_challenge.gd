class_name DailyChallenge
extends Node

var server_fetch_time = ""
var local_fetch_time = ""
var expiration_time = ""
var tasks = []  # the actual challege tasks

func _init():
	self.load_from_storage()
	if self.tasks:
		print("Challenge loaded from storage")
		if self.is_expired():
			print("Loaded Challenge expired so fetch from remote")
			# Challenge is expired, fetch from the server (using await)
			await self.fetch_from_remote()
			self.save_to_storage()
	else:
		print("Challenge fetched from remote")
		# Data doesn't exist in local storage, fetch from the server (using await)
		await self.fetch_from_remote()
		self.save_to_storage()

func fetch_from_remote():
	# fetch data from api
	var data
	var server_response = self.mock_call_api()
	# parse the json string into a dictionary
	data = JSON.parse_string(server_response)
	# simulate a 1 sec delay calling the api
	#await get_tree().create_timer(2.0).timeout
	await self.mock_delay()
	
	if data:
		# extract data into instance attributes
		tasks = data.tasks
		server_fetch_time = data.server_fetch_time
		local_fetch_time = Time.get_datetime_string_from_system(true)
		expiration_time = data.expiration_time
	print("Done fetching Challenge from remote")
	
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
	
func mock_delay():
	# Simulate a 2-second delay using a while loop
	var start_time = Time.get_ticks_msec()
	var delay_duration = 1000  # 2 seconds in milliseconds
	while Time.get_ticks_msec() - start_time < delay_duration:
		pass

func mock_call_api():
	var server_response = '{
		"tasks": [
		{
			"type": "collect",
			"target": "coins",
			"number": 50,
			"description": "Collect 50 coins"
		},
		{ 
			"type": "collect",
			"target": "shields",
			"number": 2,
			"description": "Collect 2 shields"
		},
		{ 
			"type": "destroy",
			"target": "walls",
			"number": 6,
			"description": "Destroy 6 walls"
		},
		{ 
			"type": "destroy",
			"target": "cactus",
			"number": 10,
			"description": "Collect 10 cacti"
		},
		{ 
			"type": "drive-over",
			"target": "roofs",
			"number": 3,
			"description": "Drive over 10 roofs"
		}],
		"expiration_time" : "2023-10-12T02:34:01+00:00",
		"server_fetch_time" : "2023-10-12T01:23:01+00:00"
	}'
	return server_response
